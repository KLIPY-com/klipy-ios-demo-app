//
//  AdParameters.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 07.02.25.
//

import CoreTelephony
import AdSupport
import UIKit

struct AdParameters {
  static let shared = AdParameters()
  
  var parameters: [String: Any] {
    var params: [String: Any] = [:]
    
    // Device Info
    params["ad-os"] = "ios"
    params["ad-osv"] = UIDevice.current.systemVersion
    params["ad-make"] = "apple"
    params["ad-model"] = "iphone"
    params["ad-device-w"] = UIScreen.main.bounds.width
    params["ad-device-h"] = UIScreen.main.bounds.height
    params["ad-pxratio"] = UIScreen.main.scale
    
    // Ad dimensions
    params["ad-min-width"] = 50
    params["ad-max-width"] = UIScreen.main.bounds.width - 20
    params["ad-min-height"] = 50
    params["ad-max-height"] = 200
    
    let identifierForAdvertising = ASIdentifierManager.shared().advertisingIdentifier
    params["ad-ifa"] = identifierForAdvertising.uuidString
    params["ad-language"] = "EN"
    
    return params
  }
}

extension Dictionary where Key == String, Value == Any {
  func withAdParameters() -> [String: Any] {
    self.merging(AdParameters.shared.parameters) { current, _ in current }
  }
}
