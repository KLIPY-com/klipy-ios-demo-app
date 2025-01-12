//
//  CocaColaTargetType.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation
import Moya
import UIKit

public protocol CocaColaTargetType: Moya.TargetType, Moya.AccessTokenAuthorizable {
  var mayRunAsBackgroundTask: Bool { get }
  var baseUrlSuffix: String { get }
  var overrideApiVersion: String? { get }
}

public extension CocaColaTargetType {
  static func generateRequestID() -> String {
    return UUID().uuidString
  }
}

public extension CocaColaTargetType {
  var baseURL: URL {
    return URL(string: "https://example.use-cocacolatargettype")!
  }

  var validationType: ValidationType {
    return .successCodes
  }

  var buildVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }

  var headers: [String: String]? {
    return [
      "Content-Type": "application/json",
      "Accept": "text/plain",
      "Accept-Language": GlobalAcceptLanguageSettings.shared.acceptLanguageHeader,
      "X-Platform": "ios",
      "X-RequestId": Self.generateRequestID(),
      "X-Build-Version": buildVersion,
      "X-Device-Model": UIDevice.current.model
    ]
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
