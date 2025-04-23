//
//  ChatFeatureViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import AVKit
import Foundation
import Observation
import SwiftUI

@Observable
final class ChatFeatureViewModel {
  var chatPreviewModel: ChatPreviewModel

  var isMediaPickerPresented: Bool = false

  @ObservationIgnored
  private var videoPlayers: [String: AVPlayer] = [:]

  private let mediaResponses = [
    "Haha Nice GIF!",
    "Love this one! 😂",
    "OMG that's hilarious",
    "Perfect reaction!",
    "This made my day",
    "So funny!",
    "That's exactly how I feel",
    "Good one!",
    "LOL",
    "This is gold!",
    "Cracked me up!",
    "Same energy.",
    "Accurate.",
    "Spot on!",
    "Couldn't have picked a better one.",
    "Mood.",
    "Too good! 😂",
    "Relatable.",
    "I can't 😂",
    "Great find!",
    "Nailed it!",
    "Sending this to everyone.",
    "Yes! Exactly this.",
    "Perfection.",
  ]

  public var currentlyPlayingID: String?

  public init(chatPreviewModel: ChatPreviewModel) {
    self.chatPreviewModel = chatPreviewModel
  }

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
      chatPreviewModel.messages.append(newMessage)
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
      chatPreviewModel.messages.append(newMessage)
    }

    simulateMediaReply()
  }

  func toggleMediaPicker() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.isMediaPickerPresented.toggle()
    }
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
        self.chatPreviewModel.messages.append(reply)
        SoundManager.shared.gotMessageSound()
      }
    }
  }

  private func simulateMediaReply() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let randomResponse = self.mediaResponses.randomElement() ?? "Nice!"
      let reply = Message(
        content: randomResponse,
        mediaItem: nil,
        isFromCurrentUser: false,
        timestamp: Date()
      )

      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        self.chatPreviewModel.messages.append(reply)
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
      let currentPlayer = videoPlayers[currentID]
    {
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

  func cleanUp() {
    chatPreviewModel.messages = chatPreviewModel.originalNonMutableMessages
    isMediaPickerPresented = false
    videoPlayers.forEach { (messageID, player) in
      NotificationCenter.default.removeObserver(
        self,
        name: .AVPlayerItemDidPlayToEndTime,
        object: player.currentItem
      )

      player.pause()
      player.replaceCurrentItem(with: nil)
    }

    videoPlayers.removeAll()

    currentlyPlayingID = nil
  }
}
