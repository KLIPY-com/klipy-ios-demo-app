//
//  AvatarView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI

// MARK: - Avatar View
struct AvatarView: View {
  let isOnline: Bool
  let theme: ChatPreviewTheme
  
  var body: some View {
    ZStack(alignment: .bottomTrailing) {
      Circle()
        .fill(theme.colors.avatarBackground)
        .frame(
          width: theme.sizes.avatarDiameter,
          height: theme.sizes.avatarDiameter
        )
        .overlay(
          Image(systemName: "person.fill")
            .foregroundColor(theme.colors.avatarForeground)
            .font(.system(size: theme.sizes.avatarIconSize))
        )
      
      if isOnline {
        OnlineStatusIndicator(theme: theme)
      }
    }
  }
}
