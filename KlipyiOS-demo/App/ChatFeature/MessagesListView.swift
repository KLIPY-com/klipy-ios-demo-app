//
//  MessagesListView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI

struct MessagesListView: View {
  let messages: [Message]
  let viewModel: ChatFeatureViewModel
  
  var body: some View {
    LazyVStack {
      ForEach(messages) { message in
        MessageBubble(message: message, viewModel: viewModel)
          .id(message.id)
          .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .opacity
          ))
      }
    }
    .padding(.vertical)
  }
}
