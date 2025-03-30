//
//  ChatPreviewCell.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct ChatPreview: View {
  private let model: ChatPreviewModel
  private let theme: ChatPreviewTheme
  
  init(
    model: ChatPreviewModel,
    theme: ChatPreviewTheme = .default
  ) {
    self.model = model
    self.theme = theme
  }
  
  var body: some View {
    HStack(spacing: theme.spacing.horizontal) {
      AvatarView(
        isOnline: model.isOnline,
        theme: theme
      )
      
      ChatInfoView(
        model: model,
        theme: theme
      )
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
    .background(theme.colors.background)
  }
}

#Preview {
  ChatPreview(model: ChatPreviewModel(
    name: "John",
    lastMessage: "Seen",
    time: "19.02.14",
    unreadCount: 2,
    isOnline: true, messages: []
  ), theme: .default)
}
