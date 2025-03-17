//
//  MediaSearchConfiguration.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import Foundation
import SwiftUI

struct MediaSearchConfiguration {
  struct Layout {
    static let cornerRadius: CGFloat = 8
    static let categoryIconSize: CGFloat = 22
    static let controlSize: CGFloat = 24
    static let horizontalSpacing: CGFloat = 12
    static let categorySpacing: CGFloat = 16
    static let searchBarHeight: CGFloat = 28
    static let gradientWidth: CGFloat = 20
    static let categoriesWidth: CGFloat = 165
    
    static let contentPadding = EdgeInsets(
      top: 12,
      leading: 12,
      bottom: 12,
      trailing: 12
    )
  }
  
  struct Colors {
    static let background = Color.white
    static let icon = Color.gray
    static let selectedIcon = Color.init(hex: "F8DC3B")
    static let text = Color.white
  }
  
  struct Animation {
    static let categoryTransition = SwiftUI.Animation.default
    static let imageTransition = AnyTransition.fade(duration: 0.5)
  }
}
