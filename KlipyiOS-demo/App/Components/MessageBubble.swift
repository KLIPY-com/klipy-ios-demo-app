//
//  MessageBubble 2.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import AVKit

struct MessageBubble: View {
  @State var player: AVPlayer?
  @State var isPlaying: Bool = false
  @State private var isVideoURLValid: Bool = false
  
  let viewModel: ChatFeatureViewModel

  let message: Message
  
  public init(message: Message, viewModel: ChatFeatureViewModel) {
    self.message = message
    self.viewModel = viewModel
    
    if message.isMessageContaintsMp4,
       let mediaItem = message.mediaItem,
       let mp4Media = mediaItem.mp4Media,
       let mp4UrlString = mp4Media.mp4?.url,
       let url = URL(string: mp4UrlString) {
        if UIApplication.shared.canOpenURL(url) {
          viewModel.registerVideoPlayer(for: message.id, url: url)
        }
     }
  }
  
  var body: some View {
    HStack {
      if message.isFromCurrentUser {
        Spacer()
      }
      
      VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
        if let mediaItem = message.mediaItem {
          if message.isMessageContaintsMp4 {
            VideoPlayer(player: viewModel.getPlayer(for: message.id)) {
              Button {
                isPlaying.toggle()
                if isPlaying {
                  viewModel.playVideo(for: message.id)
                } else {
                  viewModel.pauseVideo(for: message.id)
                }
              } label: {
                Image(systemName: viewModel.currentlyPlayingID == message.id ? "" : "play")
                  .foregroundColor(.white)
                  .padding()
              }
            }
            .frame(width: mediaItem.width * 1.5, height: mediaItem.height * 1.5, alignment: .center)
            .cornerRadius(16)
            .onChange(of: viewModel.currentlyPlayingID) { oldValue, newValue in
              isPlaying = newValue == message.id
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

