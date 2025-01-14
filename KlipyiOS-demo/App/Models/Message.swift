//
//  Message.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Foundation

struct Message: Identifiable {
  let id = UUID()
  let content: String
  let isFromCurrentUser: Bool
  let timestamp: Date
  
  // Example messages for preview
  static let examples = [
    Message(content: "Hey there! How are you?", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3600)),
    Message(content: "I'm doing great, thanks! How about you?", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3500)),
    Message(content: "Just working on some new features", isFromCurrentUser: false, timestamp: Date().addingTimeInterval(-3400)),
    Message(content: "That sounds interesting!", isFromCurrentUser: true, timestamp: Date().addingTimeInterval(-3300))
  ]
}
