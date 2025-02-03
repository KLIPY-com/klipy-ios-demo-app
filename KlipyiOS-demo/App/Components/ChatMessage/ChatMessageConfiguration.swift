//
//  ChatMessageConfiguration.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import Foundation

struct ChatMessageConfiguration {
  struct Layout {
    static let cornerRadius: CGFloat = 16
    static let contentPadding = EdgeInsets(
      top: 12,
      leading: 12,
      bottom: 12,
      trailing: 12
    )
    static let messagePadding = EdgeInsets(
      top: 4,
      leading: 16,
      bottom: 4,
      trailing: 16
    )
  }
  
  struct Colors {
    static let userMessage = Color(hex: "F8DC3B")
    static let otherMessage = Color(hex: "#8800FF")
    static let userMessageText = Color.black
    static let otherMessageText = Color.white
  }
}
