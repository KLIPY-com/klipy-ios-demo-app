//
//  ChatMessageView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI

struct ChatMessageView: View {
  let message: Message
  let viewModel: ChatFeatureViewModel
  
  @State private var isPlaying: Bool = false
  
  init(message: Message, viewModel: ChatFeatureViewModel) {
    self.message = message
    self.viewModel = viewModel
    
    if message.isMessageContaintsMp4,
       let mediaItem = message.mediaItem,
       let mp4Media = mediaItem.mp4Media,
       let mp4UrlString = mp4Media.mp4?.url,
       let url = URL(string: mp4UrlString),
       UIApplication.shared.canOpenURL(url) {
      viewModel.registerVideoPlayer(for: message.id, url: url)
    }
  }
  
  var body: some View {
    HStack {
      if message.isFromCurrentUser {
        Spacer()
      }
      
      VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 8) {
          messageContent
            .padding(.bottom, 4)
        
        if !message.content.isEmpty {
          messageText
        }
      }
      .padding(ChatMessageConfiguration.Layout.messagePadding)
      
      if !message.isFromCurrentUser {
        Spacer()
      }
    }
  }
  
  // MARK: - Subviews
  
  @ViewBuilder
  private var messageContent: some View {
    if let mediaItem = message.mediaItem {
      if message.isMessageContaintsMp4 {
        VideoContentView(
          mediaItem: mediaItem,
          message: message,
          viewModel: viewModel,
          isPlaying: $isPlaying
        )
      } else {
        ImageContentView(mediaItem: mediaItem)
      }
    }
  }
  
  @ViewBuilder
  private var messageText: some View {
    if !message.content.isEmpty {
      Text(message.content)
        .fixedSize(horizontal: false, vertical: true)
        .padding(ChatMessageConfiguration.Layout.contentPadding)
        .background(
          message.isFromCurrentUser ?
          ChatMessageConfiguration.Colors.userMessage :
            ChatMessageConfiguration.Colors.otherMessage
        )
        .foregroundColor(
          message.isFromCurrentUser ?
          ChatMessageConfiguration.Colors.userMessageText
          : ChatMessageConfiguration.Colors.otherMessageText
        )
        .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
    }
  }
}
