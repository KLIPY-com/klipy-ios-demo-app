//
//  GifServiceUseCase.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Foundation
import Moya

public struct GifServiceUseCase {
  private let client: RestApiProtocol
  
  public init() {
    self.client = RestApi.liveValue
  }
  
  func fetchTrending(page: Int, perPage: Int, customerId: String = CustomerIDManager.customerID, locale: String = "ka") async throws -> AnyResponse<GifItem> {
    try await client.request(
      GifService.trending(page: page, perPage: perPage, customerId: customerId, locale: locale)
    )
  }
  
  func searchGifs(query: String, page: Int, perPage: Int, customerId: String = CustomerIDManager.customerID, locale: String = "ka") async throws -> AnyResponse<GifItem> {
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
    customerId: String = CustomerIDManager.customerID
  ) async throws -> AnyResponse<GifItem> {
    try await client.request(
      GifService.recent(customerId: customerId, page: page, perPage: perPage)
    )
  }
  
  func trackView(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      GifService.view(slug: slug,customerId: customerId)
    )
  }
  
  func trackShare(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      GifService.share(
        slug: slug,
        customerId: customerId
      )
    )
  }
  
  func reportGif(
    slug: String,
    reason: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      GifService.report(slug: slug, customerId: customerId, reason: reason)
    )
  }
  
  func hideFromRecent(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      GifService.hideFromRecent(
        customerId: customerId,
        slug: slug
      )
    )
  }
}
