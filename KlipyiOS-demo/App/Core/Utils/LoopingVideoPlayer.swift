//
//  LoopingVideoPlayer.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 26.01.25.
//

import SwiftUI
import AVFoundation
import UIKit
import AVKit

struct LoopingVideoPlayer: UIViewControllerRepresentable {
  @Binding var isPlaying: Bool
  
  let url: URL
  private let player: AVPlayer
  
  init(url: URL, isPlaying: Binding<Bool>) {
    self.url = url
    self.player = AVPlayer(url: url)
    self._isPlaying = isPlaying
  }
  
  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    controller.player = player
    controller.showsPlaybackControls = false
    
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: player.currentItem,
      queue: .main) { _ in
        if isPlaying {
          player.seek(to: .zero)
          player.play()
        }
      }
    
    if isPlaying {
      player.play()
    }
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    if isPlaying {
      player.play()
    } else {
      player.pause()
    }
  }
}
