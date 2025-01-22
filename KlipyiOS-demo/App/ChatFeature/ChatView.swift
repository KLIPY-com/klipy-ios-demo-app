//
//  ChatDetailView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct ChatView: View {
  @State private var messageText = ""
  @State private var messages = Message.examples
  @State private var isMediaPickerPresented = false
  @State private var scrollProxy: ScrollViewProxy?
  @FocusState private var isFocused: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack {
            ForEach(messages) { message in
              MessageBubble(message: message)
                .id(message.id)
                .transition(.asymmetric(
                  insertion: .move(edge: .trailing).combined(with: .opacity),
                  removal: .opacity
                ))
            }
          }
          .padding(.vertical)
        }
        .onAppear {
          scrollProxy = proxy
          scrollToBottom()
        }
        .onChange(of: messages.count) { _ in
          scrollToBottom()
        }
      }
      
      MessageInputView(
        messageText: $messageText,
        isFocused: _isFocused,
        onSendMessage: sendMessage,
        onMediaPickerTap: { isMediaPickerPresented = true }
      )
    }
    .navigationTitle("John")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $isMediaPickerPresented) {
      DynamicMediaView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    .background(Color(red: 41/255, green: 46/255, blue: 50/255))
  }
  
  private func scrollToBottom() {
    withAnimation(.easeOut(duration: 0.3)) {
      scrollProxy?.scrollTo(messages.last?.id, anchor: .bottom)
    }
  }
  
  private func sendMessage() {
    let trimmedText = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else { return }
    
    SoundManager.shared.playMessageSound()
    
    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
      let newMessage = Message(
        content: trimmedText,
        isFromCurrentUser: true,
        timestamp: Date()
      )
      messages.append(newMessage)
      messageText = ""
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        let reply = Message(
          content: "Thanks for your message!",
          isFromCurrentUser: false,
          timestamp: Date()
        )
        messages.append(reply)
        SoundManager.shared.playMessageSound()
      }
    }
  }
}
