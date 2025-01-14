//
//  SoundManager.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import AVFoundation
import Foundation

// MARK: - Sound Manager
class SoundManager {
  static let shared = SoundManager()
  private var audioPlayer: AVAudioPlayer?
  
  func playMessageSound() {
    guard let soundURL = Bundle.main.url(forResource: "message_sent", withExtension: "wav") else {
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
    } catch {
      print("Error playing sound: \(error)")
    }
  }
}
