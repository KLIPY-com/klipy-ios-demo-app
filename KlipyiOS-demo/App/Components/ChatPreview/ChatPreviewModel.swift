//
//  ChatPreviewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

struct ChatPreviewModel {
  let name: String
  let lastMessage: String
  let time: String
  let unreadCount: Int
  let isOnline: Bool
  var messages: [Message]
  let originalNonMutableMessages: [Message]
  
  init(
    name: String,
    lastMessage: String,
    time: String,
    unreadCount: Int = 0,
    isOnline: Bool = true,
    messages: [Message]
  ) {
    self.name = name
    self.lastMessage = lastMessage
    self.time = time
    self.unreadCount = unreadCount
    self.isOnline = isOnline
    self.messages = messages
    self.originalNonMutableMessages = messages
  }
}
