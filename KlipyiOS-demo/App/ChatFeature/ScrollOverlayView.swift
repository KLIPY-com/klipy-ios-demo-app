//
//  ScrollOverlayView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI

struct ScrollOverlayView: View {
  let dragOffset: CGFloat
  let isFocused: Bool
  
  var body: some View {
    Group {
      if dragOffset > 0 && isFocused {
        VStack {
          Image(systemName: "keyboard.chevron.compact.down")
            .foregroundColor(.gray)
            .font(.system(size: 24))
            .opacity(min(1, dragOffset / 50))
          Spacer()
        }
        .padding(.top)
      }
    }
  }
}
