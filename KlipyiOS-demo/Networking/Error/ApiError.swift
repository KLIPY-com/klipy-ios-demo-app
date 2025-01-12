public enum APIErrorCode: String, Decodable, Sendable {
  case unAuthorized401
  case sessionNotFound
  case unknown
}

public enum APIError: Error, Equatable {
  case predefined(APIErrorCode)
  case unknown(String, String)
  case generalError(String, NetworkLayerErrorReason)
  case other(NetworkLayerError)
  case handled
  case custom(errorMessage: String, isPermanentlyBlocked: Bool, unlockTimeUTC: String?)
}
