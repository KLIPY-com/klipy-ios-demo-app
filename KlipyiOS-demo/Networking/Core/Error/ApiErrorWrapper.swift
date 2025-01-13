public struct ApiErrorWrapper: Error, Equatable {
  public let error: Error

  public init(_ error: Error) {
    self.error = error
  }

  public static func == (lhs: ApiErrorWrapper, rhs: ApiErrorWrapper) -> Bool {
    return lhs.error.localizedDescription == rhs.error.localizedDescription
  }
}
