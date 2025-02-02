//
//  HealthCheckServiceUseCase.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Foundation

public struct HealthCheckServiceUseCase {
  private let client: RestApiProtocol

  public init() {
    self.client = RestApi.liveValue
  }

  func fetchUpdateInfo() async throws -> MediaContent {
    try await client.request(HealthCheckService.healthCheck(CustomerIDManager.customerID))
  }
}
