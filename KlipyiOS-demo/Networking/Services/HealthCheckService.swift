//
//  Gifs.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//

import Moya

public enum HealthCheckService {
  case healthCheck(String)
}

extension HealthCheckService: KlipyTargetType {
  public var path: String {
    return "/health-check"
  }
  
  public var method: Method {
    return .get
  }
  
  public var authorizationType: Moya.AuthorizationType? {
    return .none
  }
  
  public var task: Moya.Task {
    switch self {
    case .healthCheck(let cusetomerId):
      return .requestParameters(parameters: [
        "customer_id": cusetomerId
      ], encoding: URLEncoding.default)
    }
  }
}

public struct HealthCheckServiceUseCase {
  private let client: RestApiProtocol

  public init() {
    self.client = RestApi.liveValue
  }

  func fetchUpdateInfo() async throws -> MediaContent {
    try await client.request(HealthCheckService.healthCheck(CUSTOMER_ID))
  }
}
