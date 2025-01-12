import Alamofire
import ApplicationEventsClient
import DataModel
import Dependencies
import Foundation
import JSONDecodeHelper
import Moya
import SecureStorageClient
import UIKit

public protocol NetworkingProviderProtocol {
  associatedtype Target: Moya.TargetType
  func request<ResponseType: Decodable>(_ target: Target, progress: @escaping ProgressBlock) async throws -> ResponseType
}

public class NetworkingProvider<Target>: NetworkingProviderProtocol where Target: Moya.TargetType {
  private let provider: MoyaProvider<Target>

  @Dependency(\.applicationEventsClient) var eventsClient

  public init(
    endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
    requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
    stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
    callbackQueue: DispatchQueue? = nil,
    trackInflights: Bool = false,
    bearerTokenClosure: @escaping () -> String?
  ) {
    self.provider = MoyaProvider(
      endpointClosure: endpointClosure,
      requestClosure: requestClosure,
      stubClosure: stubClosure,
      callbackQueue: callbackQueue,
      plugins: [
        NetworkLoggerPlugin(
          configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        ),
        AccessTokenPlugin(tokenClosure: { _ in
          bearerTokenClosure() ?? ""
        }),
        AccessTokenSavingPlugin(),
        URLRequestCachePlugin(),
        TokenRefreshPlugin()
      ],
      trackInflights: trackInflights
    )
  }

  public func request<ResponseType: Decodable>(_ target: Target, progress: @escaping ProgressBlock = { _ in }) async throws -> ResponseType {
    let asyncRequestWrapper = AsyncMoyaRequestWrapper { [weak self] continuation in
      guard let self = self else {
        return nil
      }
      return self.request(target, progress: progress) { result in
        switch result {
        case let .success(response):
          continuation.resume(returning: .success(response))
        case let .failure(moyaError):
          continuation.resume(returning: .failure(moyaError))
        }
      }
    }

    return try await withTaskCancellationHandler(operation: {
      let response = await withCheckedContinuation { continuation in
        asyncRequestWrapper.perform(continuation: continuation)
      }

      switch response {
      case let .success(success):
        do {
          return try handleSuccess(response: success)
        } catch {
          guard let moayaError = error as? MoyaError else {
            throw error
          }

          throw try await handleFailure(failure: moayaError)
        }
      case let .failure(failure):
        throw try await handleFailure(failure: failure)
      }
    }, onCancel: {
      asyncRequestWrapper.cancel()
    })
  }

  private func handleFailure(failure: MoyaError) async throws -> any Error {
    @Dependency(\.applicationEventsClient) var applicationEvents

    var errorItem: ApiErrorItem?

    let serverErrorResponse = try? JSONDecoder().decode(ApiResponse<CodeEnterEligibility>.self, from: failure.response?.data ?? Data())

    print(failure.response?.description)
    print(failure.errorDescription)

    if let serverError = serverErrorResponse {
      return CustomCodeEligibilityError(apiResponse: serverError)
    }

    switch failure.asApiErrorReason {
    case .objectMapping:
      return NetworkLayerError(
        reason: failure.asApiErrorReason,
        moyaError: failure,
        statusCode: failure.errorCode,
        apiErrorItem: errorItem
      )
    default:
      break
    }

    let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: failure.response?.data ?? Data())
    if let errorResponse, APIError.predefined(.sessionNotFound) == errorResponse.errorToThrow {
      await applicationEvents.send(event: .sessionExpired)
      return APIError.handled
    } else if let errorResponse {
      return errorResponse.errorToThrow
    }

    if let response = failure.response, response.statusCode != 400 {
      let errorsDictionary = try (response.mapJSON() as? [String: Any])
      let errorJSON = try JSONSerialization.data(withJSONObject: errorsDictionary, options: [])

      errorItem = (try? JSONDecoder().decode(ApiErrorItem.self, from: errorJSON)) ?? nil

      await eventsClient.send(event: .globalNetworkError(with: errorItem?.errorMessage ?? "Networking Error"))
    }

    if let response = failure.response, response.statusCode == 403 {
      print("👨‍🎨 403 Unauthorized")
      eventsClient.syncSend(event: .userBlocked)
    }

    return NetworkLayerError(
      reason: failure.asApiErrorReason,
      moyaError: failure,
      statusCode: failure.errorCode,
      apiErrorItem: errorItem
    )
  }

  private func handleSuccess<ResponseType: Decodable>(response: Response) throws -> ResponseType {
    let filteredResponse = try response.filterSuccessfulStatusCodes()
    return try filteredResponse.map(ResponseType.self, using: JSONDecoder.custom)
  }

  private func request(
    _ target: Target,
    callbackQueue: DispatchQueue? = .none,
    progress: ProgressBlock? = .none,
    completion: @escaping Completion
  ) -> any Cancellable {
    return provider.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
  }
}

public struct CustomCodeEligibilityError: Error {
  public let apiResponse: ApiResponse<CodeEnterEligibility>
}
