//
//  ChatDetailView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
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

struct MessagesListView: View {
  let messages: [Message]
  let currentPlayingID: String?
  let onPlayingChange: (String?) -> Void
  
  var body: some View {
    LazyVStack {
      ForEach(messages) { message in
        MessageBubble(
          isPlaying: playingBinding(for: message),
          message: message
        )
        .id(message.id)
        .transition(.asymmetric(
          insertion: .move(edge: .trailing).combined(with: .opacity),
          removal: .opacity
        ))
      }
    }
    .padding(.vertical)
  }
  
  private func playingBinding(for message: Message) -> Binding<Bool> {
    Binding(
      get: {
        // If currentPlayingID is nil (no message is playing),
        // and this is the message being set to play, return true
        if currentPlayingID == nil && message.id.description == message.id.description {
          return true
        }
        return currentPlayingID == message.id.description
      },
      set: { isPlaying in
        onPlayingChange(isPlaying ? message.id.description : nil)
      }
    )
  }
}

struct ChatView: View {
  @State private var messageText = ""
  @State private var messages = Message.examples
  @State private var isMediaPickerPresented = false
  @State private var scrollProxy: ScrollViewProxy?
  @FocusState private var isFocused: Bool
  @State private var dragOffset: CGFloat = 0
  @State private var currentPlayingID: String?
  
  var body: some View {
    VStack(spacing: 0) {
      chatScrollView
      
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
      DynamicMediaView(onSend: handleMediaSend)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    .background(Color(red: 41/255, green: 46/255, blue: 50/255))
  }
  
  private var chatScrollView: some View {
    ScrollViewReader { proxy in
      ScrollView {
        MessagesListView(
          messages: messages,
          currentPlayingID: currentPlayingID,
          onPlayingChange: { currentPlayingID = $0 }
        )
      }
      .onAppear {
        scrollProxy = proxy
        scrollToBottom()
      }
      .onChange(of: messages.count) { _, _ in
        scrollToBottom()
      }
      .simultaneousGesture(createDragGesture())
      .overlay(ScrollOverlayView(dragOffset: dragOffset, isFocused: isFocused))
    }
  }

  private func createDragGesture() -> some Gesture {
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
  }

  private func handleMediaSend(_ item: GridItemLayout) {
    isMediaPickerPresented = false
    sendMediaMessage(item: item)
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
