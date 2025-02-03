//
//  ChatDetailView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct CustomNavigationBar: View {
  let onBack: () -> Void
  
  var body: some View {
    HStack {
      Button(action: onBack) {
        Text("Back")
          .foregroundColor(Color.init(hex: "#F8DC3B"))
          .font(.system(size: 20))
      }
      .padding(.leading, 16)
      
      Spacer()
      
      VStack {
        AvatarView(isOnline: true, theme: .default)
          .frame(width: 30, height: 30)
          .padding(.top, 16)
        Spacer()
        Text("John Brown")
          .foregroundStyle(.white)
          .font(.system(size: 17, weight: .bold))
      }
      
      Spacer()
      
      
      
      // Empty view to balance the HStack
      Color.clear
        .frame(width: 44) // Same as back button area
    }
    .frame(height: 84)
    .background(Color.init(hex: "#19191C"))
  }
}

struct ChatView: View {
  @State private var viewModel = ChatFeatureViewModel()
  @State private var messageText = ""
  @State private var scrollProxy: ScrollViewProxy?
  @FocusState private var isFocused: Bool
  @State private var dragOffset: CGFloat = 0
  
  @Environment(\.dismiss) private var dismiss
  
  
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(onBack: {
        dismiss()
      })
      
      chatScrollView
      
      MessageInputView(
        messageText: $messageText,
        isFocused: _isFocused,
        onSendMessage: handleSendMessage,
        onMediaPickerTap: viewModel.toggleMediaPicker
      )
    }
    .navigationBarHidden(true)
    .sheet(isPresented: $viewModel.isMediaPickerPresented) {
      DynamicMediaView(onSend: handleMediaSend)
        .presentationDetents([
          .custom(CustomDetent.self)
        ])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(60)
    }
    .background(Color.init(hex: "#19191C"))
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

struct CustomDetent: CustomPresentationDetent {
  static func height(in context: Context) -> CGFloat? {
    return context.maxDetentValue - 1
  }
}
