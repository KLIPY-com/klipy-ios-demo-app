//
//  Provider.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//

import Foundation

extension NetworkingProvider {
  public static var liveValue: NetworkingProvider {
    return NetworkingProvider()
  }
}

extension RestApi {
  public static var liveValue: RestApi {
    return RestApi(baseURL: URL(string: "https://api.klipy.co/api/v1/sandbox-mJokm7E2jH")!, provider: NetworkingProvider.liveValue)
  }
}
