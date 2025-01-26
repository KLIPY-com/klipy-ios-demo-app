//
//  VideoPlayer.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 26.01.25.
//

import SwiftUI
import AVFoundation
import UIKit
import AVKit

struct CasualVideoPlayer: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let controller = AVPlayerViewController()
    controller.player = AVPlayer(url: url)
    controller.showsPlaybackControls = false
    controller.player?.play()
    return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
