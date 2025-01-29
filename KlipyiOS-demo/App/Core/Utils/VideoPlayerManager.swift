//
//  VideoPlayerManager.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 29.01.25.
//

import Foundation
import Combine

class VideoPlayerManager: ObservableObject {
  @Published var currentlyPlayingID: String?
  static let shared = VideoPlayerManager()
  
  private init() {}
  
  func play(videoID: String) {
    if currentlyPlayingID != videoID {
      currentlyPlayingID = videoID
    }
  }
  
  func stop() {
    currentlyPlayingID = nil
  }
}
