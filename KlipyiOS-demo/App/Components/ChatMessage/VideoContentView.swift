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
    VideoPlayer(player: viewModel.getPlayer(for: message.id)) {
      playButton
    }
    .frame(
      width: mediaItem.width * 1.5,
      height: mediaItem.height * 1.5,
      alignment: .center
    )
    .aspectRatio(contentMode: .fill)
    .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
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
