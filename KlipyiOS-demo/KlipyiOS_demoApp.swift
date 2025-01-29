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
        .onAppear {
          let useCase = HealthCheckServiceUseCase()
          let gifsUseCase = GifServiceUseCase()
          Task {
            try await useCase.fetchUpdateInfo()
            try await gifsUseCase.fetchTrending(page: 1, perPage: 10)
          }
        }
        .preferredColorScheme(.dark)
    }
  }
}
