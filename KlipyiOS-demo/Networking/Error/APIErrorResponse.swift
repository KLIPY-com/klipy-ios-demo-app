public struct APIErrorResponse: Decodable {
  struct ErrorBody: Decodable {
    let isError: Bool
    let errorMessage: String
    let statusType: NetworkLayerErrorReason = .unknown

    enum CodingKeys: CodingKey {
      case isError
      case errorMessage
    }

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.isError = try container.decode(Bool.self, forKey: .isError)
      self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
    }
  }

  let error: ErrorBody

  var errorToThrow: APIError {
    if error.isError == true {
      if error.statusType == .unauthorized {
        return APIError.predefined(.unAuthorized401)
      }
      return APIError.generalError(error.errorMessage, error.statusType)
    } else {
      return .predefined(.unknown)
    }
  }
}
