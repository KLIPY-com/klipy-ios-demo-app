//
//  CocaColaTargetType.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation
import Moya
import UIKit

public protocol KlipyTargetType: Moya.TargetType {
  var mayRunAsBackgroundTask: Bool { get }
  var baseUrlSuffix: String { get }
  var overrideApiVersion: String? { get }
}

public extension KlipyTargetType {
  static func generateRequestID() -> String {
    return UUID().uuidString
  }
}

public extension KlipyTargetType {
  var baseURL: URL {
    return URL(string: "https://api.klipy.co/api/v1/sandbox-mJokm7E2jH")!
  }

  var validationType: ValidationType {
    return .successCodes
  }

  var buildVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }

  var headers: [String: String]? {
    ["User-Agent": UserAgentManager.shared.userAgent]
  }

  var mayRunAsBackgroundTask: Bool {
    false
  }

  var baseUrlSuffix: String {
    ""
  }

  var apiVersion: String {
    ""
  }

  var overrideApiVersion: String? {
    nil
  }
}
