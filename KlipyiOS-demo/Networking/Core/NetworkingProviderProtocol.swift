//
//  NetworkingProviderProtocol.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Alamofire
import Foundation
import Moya
import UIKit

public protocol NetworkingProviderProtocol {
  associatedtype Target: Moya.TargetType
  func request<ResponseType: Decodable>(_ target: Target, progress: @escaping ProgressBlock) async throws -> ResponseType
}

public class NetworkingProvider<Target>: NetworkingProviderProtocol where Target: Moya.TargetType {
  private let provider: MoyaProvider<Target>

  public init(
    endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
    requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
    stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
    callbackQueue: DispatchQueue? = nil,
    trackInflights: Bool = false
  ) {
    self.provider = MoyaProvider(
      endpointClosure: endpointClosure,
      requestClosure: requestClosure,
      stubClosure: stubClosure,
      callbackQueue: callbackQueue,
      plugins: [
        NetworkLoggerPlugin(
          configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        )
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
    var errorItem: ApiErrorItem?

    print(failure.response?.description)
    print(failure.errorDescription)
    
    switch failure {
    case .objectMapping(let error, let response):
      print("🔍 Decoding Error Details:")
      print("Error: \(error)")

        print("Response Status Code: \(response.statusCode)")
        if let responseString = String(data: response.data, encoding: .utf8) {
          print("Raw Response Data:")
          print(responseString)
        }
        
        /// If it's a DecodingError, get more specific information
        if let decodingError = error as? DecodingError {
          switch decodingError {
          case .keyNotFound(let key, let context):
            print("Key '\(key.stringValue)' not found:", context.debugDescription)
            print("Coding path:", context.codingPath)
          case .valueNotFound(let type, let context):
            print("Value of type '\(type)' not found:", context.debugDescription)
            print("Coding path:", context.codingPath)
          case .typeMismatch(let type, let context):
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("Coding path:", context.codingPath)
          case .dataCorrupted(let context):
            print("Data corrupted:", context.debugDescription)
            print("Coding path:", context.codingPath)
          @unknown default:
            print("Unknown decoding error:", decodingError.localizedDescription)
          }
        }
    default:
      print("UNknown decoding problem")
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
      return APIError.handled
    } else if let errorResponse {
      return errorResponse.errorToThrow
    }

    if let response = failure.response, response.statusCode != 400 {
      let errorsDictionary = try (response.mapJSON() as? [String: Any])
      let errorJSON = try JSONSerialization.data(withJSONObject: errorsDictionary, options: [])

      errorItem = (try? JSONDecoder().decode(ApiErrorItem.self, from: errorJSON)) ?? nil
    }

    if let response = failure.response, response.statusCode == 403 {
      print("👨‍🎨 403 Unauthorized")
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
