//
//  UserAgentManager.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 07.02.25.
//

import UIKit
import WebKit
import SwiftUI

class UserAgentManager {
  static let shared = UserAgentManager()
  var userAgent: String = ""
  var WKwebView: WKWebView!
  
  func getUserAgent() {
    DispatchQueue.main.async { [weak self] in
      let webConfiguration = WKWebViewConfiguration()
      self?.WKwebView = WKWebView(frame: .zero, configuration: webConfiguration)
      self?.WKwebView.evaluateJavaScript(
        "navigator.userAgent",
        completionHandler: { [weak self] (result, error) in
          debugPrint(result as Any)
          debugPrint(error as Any)
          
          if let unwrappedUserAgent = result as? String {
            print("userAgent: \(unwrappedUserAgent)")
            self?.userAgent = unwrappedUserAgent
          } else {
            self?.userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148)"
          }
        }
      )
    }
  }
}
