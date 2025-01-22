//
//  MessageInputView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct MessageInputView: View {
  @Binding var messageText: String
  @FocusState var isFocused: Bool

  let onSendMessage: () -> Void
  let onMediaPickerTap: () -> Void

  private var isMessageEmpty: Bool {
    messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Divider()
      HStack(spacing: 12) {
        TextField("Message", text: $messageText)
          .padding(12)
          .background(Color(.systemGray6))
          .cornerRadius(20)
          .focused($isFocused)
          .animation(.easeOut(duration: 0.2), value: messageText)
        
        // GIF Button
        Button(action: onMediaPickerTap) {
          Image(systemName: "square.grid.3x3.middle.filled")
            .foregroundColor(Color(hex: "1E68D7"))
            .font(.system(size: 20))
        }
        .transition(.scale)
        
        Button(action: {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            onSendMessage()
          }
        }) {
          Image(systemName: "paperplane.fill")
            .foregroundColor(Color(hex: "1E68D7"))
            .font(.system(size: 20))
            .rotationEffect(.degrees(isMessageEmpty ? 0 : 45))
            .scaleEffect(isMessageEmpty ? 1 : 1.2)
        }
        .disabled(isMessageEmpty)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isMessageEmpty)
      }
      .padding(.horizontal)
      .padding(.vertical, 8)
      .background(Color(red: 24/255, green: 28/255, blue: 31/255))
    }
  }
}
