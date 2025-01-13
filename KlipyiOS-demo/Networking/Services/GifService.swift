//
//  GifService.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Moya

public enum GifService {
  case trending(page: Int, perPage: Int, customerId: String, locale: String)
}

extension GifService: KlipyTargetType {
  public var path: String {
    switch self {
    case .trending:
      return "/gifs/trending"
    }
  }
  
  public var method: Method {
    return .get
  }
  
  public var task: Moya.Task {
    switch self {
    case .trending(let page, let perPage, let customerId, let locale):
      return .requestParameters(parameters: [
        "page": page,
        "per_page": perPage,
        "customer_id": customerId,
        "locale": locale
      ], encoding: URLEncoding.default)
    }
  }
}

public struct GifServiceUseCase {
  private let client: RestApiProtocol

  public init() {
    self.client = RestApi.liveValue
  }

  func fetchTrending(page: Int, perPage: Int, customerId: String = CUSTOMER_ID, locale: String = "ka") async throws -> AnyResponse<GifItem> {
    try await client.request(GifService.trending(page: page, perPage: perPage, customerId: customerId, locale: locale))
  }
}
