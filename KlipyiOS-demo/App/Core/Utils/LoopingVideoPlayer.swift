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
  let videoID: String
  @Binding var isPlaying: Bool
  let url: URL
  private let player: AVPlayer
  @ObservedObject private var playerManager = VideoPlayerManager.shared
  
  init(videoID: String, url: URL, isPlaying: Binding<Bool>) {
      self.videoID = videoID
      self.url = url
      self.player = AVPlayer(url: url)
      self._isPlaying = isPlaying
  }
  
  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> AVPlayerViewController {
      let controller = AVPlayerViewController()
      controller.player = player
      controller.showsPlaybackControls = false
      
      NotificationCenter.default.addObserver(
          forName: .AVPlayerItemDidPlayToEndTime,
          object: player.currentItem,
          queue: .main) { _ in
              if isPlaying && playerManager.currentlyPlayingID == videoID {
                  player.seek(to: .zero)
                  try? AVAudioSession.sharedInstance().setCategory(.playback)
                  player.play()
              } else {
                  context.coordinator.overlayView?.playImageView.alpha = 1
              }
          }
      
      NotificationCenter.default.addObserver(
          forName: UIScene.didEnterBackgroundNotification,
          object: nil,
          queue: .main) { _ in
              player.pause()
              try? AVAudioSession.sharedInstance().setActive(false)
          }
      
      NotificationCenter.default.addObserver(
          forName: UIScene.willDeactivateNotification,
          object: nil,
          queue: .main) { _ in
              player.pause()
              try? AVAudioSession.sharedInstance().setActive(false)
          }
      
      let overlayView = PlayButtonOverlay(videoID: videoID, isPlaying: $isPlaying)
      controller.contentOverlayView?.addSubview(overlayView)
      overlayView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          overlayView.centerXAnchor.constraint(equalTo: controller.contentOverlayView!.centerXAnchor),
          overlayView.centerYAnchor.constraint(equalTo: controller.contentOverlayView!.centerYAnchor),
          overlayView.widthAnchor.constraint(equalToConstant: 50),
          overlayView.heightAnchor.constraint(equalToConstant: 50)
      ])
      
      context.coordinator.overlayView = overlayView
      
      return controller
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
      if isPlaying && playerManager.currentlyPlayingID == videoID {
          try? AVAudioSession.sharedInstance().setCategory(.playback)
          player.play()
      } else {
          player.pause()
          try? AVAudioSession.sharedInstance().setActive(false)
          context.coordinator.overlayView?.playImageView.alpha = 1
      }
  }
  
  static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
      try? AVAudioSession.sharedInstance().setActive(false)
      NotificationCenter.default.removeObserver(coordinator)
  }
  
  class Coordinator: NSObject {
      var parent: LoopingVideoPlayer
      weak var overlayView: PlayButtonOverlay?
      
      init(_ parent: LoopingVideoPlayer) {
          self.parent = parent
      }
      
      deinit {
          NotificationCenter.default.removeObserver(self)
      }
  }
}

class PlayButtonOverlay: UIView {
  let playImageView: UIImageView
  private var isPlayingBinding: Binding<Bool>
  private let videoID: String
  private let playerManager: VideoPlayerManager
  
  init(videoID: String, isPlaying: Binding<Bool>) {
      self.videoID = videoID
      self.isPlayingBinding = isPlaying
      self.playerManager = VideoPlayerManager.shared
      
      playImageView = UIImageView(image: UIImage(systemName: "play.circle.fill"))
      playImageView.tintColor = .white
      
      super.init(frame: .zero)
      
      addSubview(playImageView)
      playImageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
          playImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
          playImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
          playImageView.widthAnchor.constraint(equalToConstant: 50),
          playImageView.heightAnchor.constraint(equalToConstant: 50)
      ])
      
      playImageView.alpha = isPlaying.wrappedValue ? 0 : 1
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      addGestureRecognizer(tapGesture)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func handleTap() {
      if isPlayingBinding.wrappedValue {
          playerManager.stop()
      } else {
          playerManager.play(videoID: videoID)
      }
      isPlayingBinding.wrappedValue.toggle()
      UIView.animate(withDuration: 0.2) {
          self.playImageView.alpha = self.isPlayingBinding.wrappedValue ? 0 : 1
      }
  }
}
