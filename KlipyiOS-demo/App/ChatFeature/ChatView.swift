//
//  ChatDetailView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct ChatView: View {
  @State private var viewModel = ChatFeatureViewModel()
  @State private var messageText = ""
  @State private var scrollProxy: ScrollViewProxy?
  @FocusState private var isFocused: Bool
  @State private var dragOffset: CGFloat = 0
  
  var body: some View {
    VStack(spacing: 0) {
      chatScrollView
      
      MessageInputView(
        messageText: $messageText,
        isFocused: _isFocused,
        onSendMessage: handleSendMessage,
        onMediaPickerTap: viewModel.toggleMediaPicker
      )
    }
    .navigationTitle("John")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $viewModel.isMediaPickerPresented) {
      DynamicMediaView(onSend: handleMediaSend)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    .background(Color(red: 41/255, green: 46/255, blue: 50/255))
    .onDisappear {
      viewModel.cleanUp()
    }
  }
  
  private var chatScrollView: some View {
    ScrollViewReader { proxy in
      ScrollView {
        MessagesListView(messages: viewModel.messages, viewModel: viewModel)
      }
      .onAppear {
        scrollProxy = proxy
        scrollToBottom()
      }
      .onChange(of: viewModel.messages.count) { _, _ in
        scrollToBottom()
      }
      .simultaneousGesture(createDragGesture())
      .overlay(ScrollOverlayView(dragOffset: dragOffset, isFocused: isFocused))
    }
  }
  
  // MARK: - Private Methods
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
    viewModel.toggleMediaPicker()
    viewModel.sendMediaMessage(item: item)
  }
  
  private func handleSendMessage() {
    viewModel.sendTextMessage(messageText)
    messageText = ""
  }
  
  private func scrollToBottom() {
    withAnimation(.easeOut(duration: 0.3)) {
      scrollProxy?.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
    }
  }
}
