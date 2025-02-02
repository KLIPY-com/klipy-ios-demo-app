//
//  ChatFeatureViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Observation
import SwiftUI
import Foundation
import AVKit

@Observable
final class ChatFeatureViewModel {
  private(set) var messages: [Message] = Message.examples
  private(set) var isMediaPickerPresented: Bool = false
  
  
  @ObservationIgnored
  private var videoPlayers: [String: AVPlayer] = [:]
  
  public var currentlyPlayingID: String?
  
  // MARK: - Public Methods
  func sendTextMessage(_ text: String) {
    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else { return }
    
    SoundManager.shared.playMessageSound()
    
    let newMessage = Message(
      content: trimmedText,
      mediaItem: nil,
      isFromCurrentUser: true,
      timestamp: Date()
    )
    
    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
      messages.append(newMessage)
    }
    
    simulateReply()
  }
  
  func sendMediaMessage(item: GridItemLayout) {
    SoundManager.shared.playMessageSound()
    
    let newMessage = Message(
      content: "",
      mediaItem: item,
      isFromCurrentUser: true,
      timestamp: Date()
    )
    
    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
      messages.append(newMessage)
    }
    
    simulateMediaReply()
  }
  
  func toggleMediaPicker() {
    isMediaPickerPresented.toggle()
  }
  
  private func simulateReply() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let reply = Message(
        content: "Thanks for your message!",
        mediaItem: nil,
        isFromCurrentUser: false,
        timestamp: Date()
      )
      
      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        self.messages.append(reply)
        SoundManager.shared.gotMessageSound()
      }
    }
  }
  
  private func simulateMediaReply() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let reply = Message(
        content: "Haha Nice GIF!",
        mediaItem: nil,
        isFromCurrentUser: false,
        timestamp: Date()
      )
      
      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        self.messages.append(reply)
        SoundManager.shared.gotMessageSound()
      }
    }
  }
  
  func registerVideoPlayer(for messageID: String, url: URL) {
    let player = AVPlayer(url: url)
    videoPlayers[messageID] = player

    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: player.currentItem,
      queue: .main
    ) { [weak self] _ in
      self?.currentlyPlayingID = nil
    }
  }
  
  func unregisterVideoPlayer(for messageID: String) {
    if currentlyPlayingID == messageID {
      currentlyPlayingID = nil
    }
    videoPlayers.removeValue(forKey: messageID)
  }
  
  func getPlayer(for messageID: String) -> AVPlayer? {
    return videoPlayers[messageID]
  }
  
  func pauseVideo(for messageID: String) {
    guard let player = videoPlayers[messageID] else { return }
    player.pause()
    player.seek(to: .zero)
    if currentlyPlayingID == messageID {
      currentlyPlayingID = nil
    }
  }
  
  func playVideo(for messageID: String) {
    guard let playerToPlay = videoPlayers[messageID] else { return }
    
    if currentlyPlayingID == messageID {
      playerToPlay.pause()
      currentlyPlayingID = nil
      return
    }
    
    if let currentID = currentlyPlayingID,
       let currentPlayer = videoPlayers[currentID] {
      currentPlayer.pause()
      currentPlayer.seek(to: .zero)
    }
    
    // Play the selected video
    playerToPlay.seek(to: .zero)
    playerToPlay.play()
    currentlyPlayingID = messageID
  }
  
  func pauseAllVideos() {
    videoPlayers.values.forEach { player in
      player.pause()
      player.seek(to: .zero)
    }
    currentlyPlayingID = nil
  }
  
  deinit {
    videoPlayers.forEach { (messageID, player) in
      NotificationCenter.default.removeObserver(
        self,
        name: .AVPlayerItemDidPlayToEndTime,
        object: player.currentItem
      )
    }
    videoPlayers.removeAll()
  }
}
