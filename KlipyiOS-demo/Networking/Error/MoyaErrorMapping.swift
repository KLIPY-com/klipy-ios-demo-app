import Foundation
import Moya

public extension MoyaError {
  var asApiErrorReason: NetworkLayerErrorReason {
    switch self {
    case .imageMapping:
      return .imageMapping
    case .jsonMapping:
      return .jsonMapping
    case .stringMapping:
      return .stringMapping
    case .objectMapping:
      return .objectMapping
    case .encodableMapping:
      return .encodableMapping
    case .statusCode:
      guard let response = response else {
        return .statusCode
      }

      return NetworkLayerErrorReason(rawValue: response.statusCode) ?? .statusCode
    case let .underlying(error, _):
      if let afError = error.asAFError, afError.isExplicitlyCancelledError {
        return .canceled
      }

      return .underlying
    case .requestMapping:
      return .requestMapping
    case .parameterEncoding:
      return .parameterEncoding
    }
  }
}
