//
//  MessageBubble 2.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct MessageBubble: View {
  let message: Message
  
  var body: some View {
    HStack {
      if message.isFromCurrentUser {
        Spacer()
      }
      
      Text(message.content)
        .padding(12)
        .background(message.isFromCurrentUser ? Color(hex: "1E68D7") : Color(.systemGray6))
        .foregroundColor(message.isFromCurrentUser ? .white : .black)
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
      
      if !message.isFromCurrentUser {
        Spacer()
      }
    }
  }
}
