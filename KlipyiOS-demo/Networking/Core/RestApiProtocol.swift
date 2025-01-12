//
//  RestApiProtocol.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation
import Moya

public protocol RestApiProtocol {
  func request<ResponseType: Decodable>(_ target: any KlipyTargetType) async throws -> ResponseType

  var baseURL: URL { get }
}

public final class RestApi: RestApiProtocol {
  public let baseURL: URL
  let provider: NetworkingProvider<KlipyMultiTarget>

  init(baseURL url: URL, provider: NetworkingProvider<KlipyMultiTarget>) {
    baseURL = url
    self.provider = provider
  }

  public func request<ResponseType: Decodable>(_ target: any KlipyTargetType) async throws -> ResponseType {
    return try await provider.request(KlipyMultiTarget(withBaseUrl: baseURL, andTarget: target))
  }
}
