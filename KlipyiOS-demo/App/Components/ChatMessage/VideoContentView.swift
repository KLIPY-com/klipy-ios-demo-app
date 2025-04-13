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
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VideoPlayer(player: viewModel.getPlayer(for: message.id)) {
          playButton
        }
        .aspectRatio(contentMode: .fit)
        .frame(
          width: min(geometry.size.width * 0.85, 300),
          height: min(calculateScaledHeight(geometry: geometry), 400)
        )
        .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
      }
    }
    .onChange(of: viewModel.currentlyPlayingID) { _, newValue in
      isPlaying = newValue == message.id
    }
  }
  
  private func calculateScaledHeight(geometry: GeometryProxy) -> CGFloat {
     let maxWidth = min(geometry.size.width * 0.85, 300)
     let aspectRatio = mediaItem.height / mediaItem.width
     return maxWidth * aspectRatio
   }
   
   private func calculateAdaptiveHeight() -> CGFloat {
     let aspectRatio = mediaItem.height / mediaItem.width
     let baseHeight = 500 * aspectRatio
     return min(max(baseHeight, 180), 400)
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
