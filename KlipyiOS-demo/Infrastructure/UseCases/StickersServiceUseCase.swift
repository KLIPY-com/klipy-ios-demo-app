//
//  StickersServiceUseCase.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Moya
import Foundation

public struct StickersServiceUseCase {
  private let client: RestApiProtocol
  
  public init() {
    self.client = RestApi.liveValue
  }
  
  func fetchTrending(
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID,
    locale: String = "ka"
  ) async throws -> AnyResponse<StickerItem> {
    try await client.request(
      StickersService.trending(
        page: page,
        perPage: perPage,
        customerId: customerId,
        locale: locale
      )
    )
  }
  
  func searchStickers(
    query: String,
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID,
    locale: String = "ka"
  ) async throws -> AnyResponse<StickerItem> {
    try await client.request(
      StickersService.search(
        query: query,
        page: page,
        perPage: perPage,
        customerId: customerId,
        locale: locale
      )
    )
  }
  
  func fetchCategories() async throws -> Categories {
    try await client.request(StickersService.categories)
  }
  
  func fetchRecentItems(
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> AnyResponse<StickerItem> {
    try await client.request(
      StickersService.recent(
        customerId: customerId,
        page: page,
        perPage: perPage
      )
    )
  }
  
  func hideFromRecent(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      StickersService.hideFromRecent(
        customerId: customerId,
        slug: slug
      )
    )
  }
  
  func trackView(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      StickersService.view(
        slug: slug,
        customerId: customerId
      )
    )
  }
  
  func trackShare(
    slug: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      StickersService.share(
        slug: slug,
        customerId: customerId
      )
    )
  }
  
  func reportSticker(
    slug: String,
    reason: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      StickersService.report(
        slug: slug,
        customerId: customerId,
        reason: reason
      )
    )
  }
}
