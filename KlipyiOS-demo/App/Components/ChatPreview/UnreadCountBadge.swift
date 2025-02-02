//
//  UnreadCountBadge.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI

// MARK: - Unread Count Badge
struct UnreadCountBadge: View {
  let count: Int
  let theme: ChatPreviewTheme
  
  var body: some View {
    ZStack {
      Circle()
        .fill(theme.colors.badge)
        .frame(
          width: theme.sizes.badgeDiameter,
          height: theme.sizes.badgeDiameter
        )
      
      Text("\(count)")
        .font(theme.fonts.badge)
        .bold()
        .foregroundColor(theme.colors.badgeText)
    }
  }
}
