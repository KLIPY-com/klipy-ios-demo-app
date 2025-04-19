//
//  VideoContentView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import AVKit

struct VideoContentView: View {
  let mediaItem: GridItemLayout
  let message: Message
  let viewModel: ChatFeatureViewModel
  
  @Binding var isPlaying: Bool
  
  private var normalizedSize: (width: CGFloat, height: CGFloat) {
    let originalWidth = mediaItem.width * 2
    let originalHeight = mediaItem.height * 2
    
    if originalWidth > 200 && originalHeight > 120 {
      let aspectRatio = originalWidth / originalHeight
      
      let maxWidth: CGFloat = 280
      let maxHeight = maxWidth / aspectRatio
      
      return (width: maxWidth, height: maxHeight)
    }
    
    return (width: originalWidth, height: originalHeight)
  }
  
  var body: some View {
    ZStack {
      VideoPlayer(player: viewModel.getPlayer(for: message.id)) {
        playButton
      }
      .frame(width: normalizedSize.width, height: normalizedSize.height)
      .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
    }
    .onChange(of: viewModel.currentlyPlayingID) { _, newValue in
      isPlaying = newValue == message.id
    }
  }
  
  private var playButton: some View {
    Button {
      handlePlayback()
    } label: {
      Image(systemName: viewModel.currentlyPlayingID == message.id ? "" : "play")
        .foregroundColor(.white)
        .padding()
    }
  }
  
  private func handlePlayback() {
    isPlaying.toggle()
    if isPlaying {
      viewModel.playVideo(for: message.id)
    } else {
      viewModel.pauseVideo(for: message.id)
    }
  }
}
