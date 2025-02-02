//
//  ClipsServiceUseCase.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

public struct ClipsServiceUseCase {
  private let client: RestApiProtocol
  
  public init() {
    self.client = RestApi.liveValue
  }
  
  func fetchTrending(
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID,
    locale: String = "ka"
  ) async throws -> AnyResponse<ClipItem> {
    try await client.request(
      ClipsService.trending(
        page: page,
        perPage: perPage,
        customerId: customerId,
        locale: locale
      )
    )
  }
  
  func searchClips(
    query: String,
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID,
    locale: String = "ka"
  ) async throws -> AnyResponse<ClipItem> {
    try await client.request(
      ClipsService.search(
        query: query,
        page: page,
        perPage: perPage,
        customerId: customerId,
        locale: locale
      )
    )
  }
  
  func fetchCategories() async throws -> Categories {
    try await client.request(ClipsService.categories)
  }
  
  func fetchRecentItems(
    page: Int,
    perPage: Int = 24,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> AnyResponse<ClipItem> {
    try await client.request(
      ClipsService.recent(
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
      ClipsService.hideFromRecent(
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
      ClipsService.view(
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
      ClipsService.share(
        slug: slug,
        customerId: customerId
      )
    )
  }
  
  func reportClip(
    slug: String,
    reason: String,
    customerId: String = CustomerIDManager.customerID
  ) async throws -> FireAndForgetResponse {
    try await client.request(
      ClipsService.report(
        slug: slug,
        customerId: customerId,
        reason: reason
      )
    )
  }
}
