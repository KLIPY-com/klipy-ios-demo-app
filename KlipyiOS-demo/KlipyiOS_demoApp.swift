//
//  KlipyiOS_demoApp.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 10.01.25.
//

import SwiftUI

@main
struct KlipyiOS_demoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .preferredColorScheme(.dark)
        .onAppear {
          UserAgentManager.shared.getUserAgent()
        }
    }
  }
}
