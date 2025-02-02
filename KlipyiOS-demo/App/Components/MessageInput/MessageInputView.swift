//
//  MessageInputView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
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
      inputContent
    }
  }
  
  private var inputContent: some View {
    HStack(spacing: MessageInputConfiguration.Layout.contentSpacing) {
      messageTextField
      mediaButton
      sendButton
    }
    .padding(MessageInputConfiguration.Layout.contentPadding)
    .background(MessageInputConfiguration.Colors.background)
  }
}

// MARK: - Subviews
private extension MessageInputView {
  var messageTextField: some View {
    TextField("Message", text: $messageText)
      .padding(MessageInputConfiguration.Layout.textFieldPadding)
      .background(MessageInputConfiguration.Colors.textFieldBackground)
      .cornerRadius(MessageInputConfiguration.Layout.cornerRadius)
      .focused($isFocused)
      .animation(
        MessageInputConfiguration.Animation.textField,
        value: messageText
      )
  }
  
  var mediaButton: some View {
    Button(action: onMediaPickerTap) {
      Image(systemName: "square.grid.3x3.middle.filled")
        .font(.system(
          size: MessageInputConfiguration.Layout.buttonSize
        ))
        .foregroundColor(MessageInputConfiguration.Colors.accent)
    }
    .transition(.scale)
  }
  
  var sendButton: some View {
    Button(action: handleSend) {
      Image(systemName: "paperplane.fill")
        .font(.system(
          size: MessageInputConfiguration.Layout.buttonSize
        ))
        .foregroundColor(MessageInputConfiguration.Colors.accent)
        .rotationEffect(.degrees(isMessageEmpty ? 0 : 45))
        .scaleEffect(isMessageEmpty ? 1 : 1.2)
    }
    .disabled(isMessageEmpty)
    .animation(
      MessageInputConfiguration.Animation.sendButton,
      value: isMessageEmpty
    )
  }
  
  func handleSend() {
    withAnimation(MessageInputConfiguration.Animation.sendButton) {
      onSendMessage()
    }
  }
}
