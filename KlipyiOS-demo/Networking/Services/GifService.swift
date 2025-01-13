//
//  GifService.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Moya

public enum GifService {
  case trending(page: Int, perPage: Int, customerId: String, locale: String)
  case search(query: String, page: Int, perPage: Int, customerId: String, locale: String)
  case categories
  case recent(customerId: String, page: Int, perPage: Int)
}

extension GifService: KlipyTargetType {
  public var path: String {
    switch self {
    case .trending:
      return "/gifs/trending"
    case .search:
      return "/gifs/search"
    case .categories:
      return "/gifs/categories"
    case .recent(let customerId, _, _):
      return "/gifs/recent/\(customerId)"
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
      
    case .search(let query, let page, let perPage, let customerId, let locale):
      return .requestParameters(parameters: [
        "q": query,
        "page": page,
        "per_page": perPage,
        "customer_id": customerId,
        "locale": locale
      ], encoding: URLEncoding.default)
    case .categories:
      return .requestPlain
    case .recent(_, let page, let perPage):
      return .requestParameters(parameters: [
        "page": page,
        "per_page": perPage
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
    try await client.request(
      GifService.trending(page: page, perPage: perPage, customerId: customerId, locale: locale)
    )
  }
  
  func searchGifs(query: String, page: Int, perPage: Int, customerId: String = CUSTOMER_ID, locale: String = "ka") async throws -> AnyResponse<GifItem> {
    try await client.request(
      GifService.search(query: query, page: page, perPage: perPage, customerId: customerId, locale: locale)
    )
  }
  
  func fetchCategories() async throws -> Categories {
    try await client.request(GifService.categories)
  }
  
  func fetchRecentItems(
    page: Int,
    perPage: Int,
    customerId: String = CUSTOMER_ID
  ) async throws -> AnyResponse<GifItem> {
    try await client.request(
      GifService.recent(
        customerId: customerId,
        page: page,
        perPage: perPage
      )
    )
  }
}
