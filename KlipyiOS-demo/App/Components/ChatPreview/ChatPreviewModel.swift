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
  
  init(
    name: String,
    lastMessage: String,
    time: String,
    unreadCount: Int = 0,
    isOnline: Bool = true
  ) {
    self.name = name
    self.lastMessage = lastMessage
    self.time = time
    self.unreadCount = unreadCount
    self.isOnline = isOnline
  }
}
