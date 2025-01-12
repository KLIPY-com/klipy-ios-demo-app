import Foundation
import Moya

public protocol RestApiProtocol {
  func request<ResponseType: Decodable>(_ target: any CocaColaTargetType) async throws -> ResponseType

  var baseURL: URL { get }
}

public final class RestApi: RestApiProtocol {
  public let baseURL: URL
  let provider: NetworkingProvider<CocaColaMultiTarget>

  init(baseURL url: URL, provider: NetworkingProvider<CocaColaMultiTarget>) {
    baseURL = url
    self.provider = provider
  }

  public func request<ResponseType: Decodable>(_ target: any CocaColaTargetType) async throws -> ResponseType {
    return try await provider.request(CocaColaMultiTarget(withBaseUrl: baseURL, andTarget: target))
  }
}
