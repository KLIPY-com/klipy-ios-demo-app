//
//  CocaColaMultiTarget.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation
import Moya

struct KlipyMultiTarget: KlipyTargetType {

  private let _baseURL: URL

  /// The baseURL of the embedded target.
  public var baseURL: URL {
    guard let target = target as? (any KlipyTargetType) else {
      return _baseURL
    }
    return URL(string: "\(_baseURL.absoluteString)\(target.baseUrlSuffix)")!
  }

  /// The embedded `TargetType`.
  public let target: any TargetType

  /// The embedded target's base `URL`.
  public var path: String { target.path }

  /// The HTTP method of the embedded target.
  public var method: Moya.Method { target.method }

  /// The sampleData of the embedded target.
  public var sampleData: Data { target.sampleData }

  /// The `Task` of the embedded target.
  public var task: Task { target.task }

  /// The `ValidationType` of the embedded target.
  public var validationType: ValidationType { target.validationType }

  /// The headers of the embedded target.
  public var headers: [String: String]? {
    target.headers
  }

  public init(withBaseUrl url: URL, andTarget target: any KlipyTargetType) {
    self._baseURL = url
    self.target = target
  }
}
