//
//  MessageInputConfiguration.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import Foundation

struct MessageInputConfiguration {
  struct Layout {
    static let cornerRadius: CGFloat = 8
    static let buttonSize: CGFloat = 20
    static let contentSpacing: CGFloat = 12
    static let textFieldPadding: CGFloat = 12
    static let contentPadding = EdgeInsets(
      top: 8,
      leading: 16,
      bottom: 8,
      trailing: 16
    )
  }
  
  struct Colors {
    static let accent = Color(hex: "F8DC3B")
    static let textFieldBackground = Color.init(hex: "36383F")
    static let background = Color.init(hex: "#14141C")
  }
  
  struct Animation {
    static let textField = SwiftUI.Animation.easeOut(duration: 0.2)
    static let sendButton = SwiftUI.Animation.spring(
      response: 0.3,
      dampingFraction: 0.6
    )
  }
}
