//
//  MessageBubble 2.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MessageBubble: View {
  let message: Message
  
  @State private var isPlaying = false
  
  var body: some View {
    HStack {
      if message.isFromCurrentUser {
        Spacer()
      }
      
      VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
        if let mediaItem = message.mediaItem {
          if message.isMessageContaintsMp4,
             let mp4Url = mediaItem.mp4Media?.mp4?.url {
            LoopingVideoPlayer(url: URL(string: mp4Url)!, isPlaying: $isPlaying)
              .frame(width: mediaItem.width * 1.5, height: mediaItem.height * 1.5)
              .cornerRadius(16)
              .onTapGesture {
                isPlaying.toggle()
              }
          } else {
            AnimatedImage(url: URL(string: mediaItem.url), isAnimating: .constant(true)) {
              WebImage(url: URL(string: mediaItem.previewUrl))
                .resizable()
                .transition(.fade)
                .aspectRatio(contentMode: .fill)
            }
            .resizable()
            .frame(width: mediaItem.width, height: mediaItem.height)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(16)
          }
        }
        
        if !message.content.isEmpty {
          Text(message.content)
            .padding(12)
            .background(message.isFromCurrentUser ? Color(hex: "1E68D7") : Color(.systemGray6))
            .foregroundColor(message.isFromCurrentUser ? .white : .white)
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 4)
      
      if !message.isFromCurrentUser {
        Spacer()
      }
    }
  }
}
  
