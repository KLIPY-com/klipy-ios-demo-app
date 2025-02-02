//
//  CategoryIconButton.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CategoryIconButton: View {
  let category: MediaCategory
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      WebImage(url: URL(string: category.iconUrl))
        .resizable()
        .renderingMode(.template)
        .indicator(.activity)
        .transition(MediaSearchConfiguration.Animation.imageTransition)
        .scaledToFit()
        .frame(
          width: MediaSearchConfiguration.Layout.categoryIconSize,
          height: MediaSearchConfiguration.Layout.categoryIconSize
        )
        .foregroundColor(
          isSelected ?
          MediaSearchConfiguration.Colors.selectedIcon :
            MediaSearchConfiguration.Colors.icon
        )
    }
    .frame(
      width: MediaSearchConfiguration.Layout.categoryIconSize,
      height: MediaSearchConfiguration.Layout.categoryIconSize
    )
  }
}
