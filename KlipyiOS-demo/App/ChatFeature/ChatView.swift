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
  @State private var dragOffset: CGFloat = 0

  
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
        .onChange(of: messages.count) { _, _ in
          scrollToBottom()
        }
        .simultaneousGesture(
          DragGesture()
            .onChanged { value in
              if value.translation.height > 0 && isFocused {
                dragOffset = value.translation.height
                if dragOffset > 50 {
                  isFocused = false
                }
              }
            }
            .onEnded { _ in
              dragOffset = 0
            }
        )
        .overlay(
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
        )
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
      DynamicMediaView(onSend: { message in
        print(message)
        isMediaPickerPresented = false
        sendMediaMessage(item: message)
      })
      .presentationDetents([.large])
      .presentationDragIndicator(.visible)
    }
    .background(Color(red: 41/255, green: 46/255, blue: 50/255))
  }
  
  private func sendMediaMessage(item: GridItemLayout) {
    SoundManager.shared.playMessageSound()
    
    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
      let newMessage = Message(
        content: "",
        mediaItem: item,
        isFromCurrentUser: true,
        timestamp: Date()
      )
      messages.append(newMessage)
    }
    
    // Simulate reply
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
        let reply = Message(
          content: "Haha Nice GIF!",
          mediaItem: nil,
          isFromCurrentUser: false,
          timestamp: Date()
        )
        messages.append(reply)
        SoundManager.shared.gotMessageSound()
      }
    }
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
        mediaItem: nil,
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
          mediaItem: nil,
          isFromCurrentUser: false,
          timestamp: Date()
        )
        messages.append(reply)
        SoundManager.shared.gotMessageSound()
      }
    }
  }
}
