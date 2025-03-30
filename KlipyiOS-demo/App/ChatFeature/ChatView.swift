//
//  ChatDetailView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI
import AlertToast

struct CustomNavigationBar: View {
  let onBack: () -> Void
  
  let title: String
  
  public init(title: String, onBack: @escaping () -> Void) {
    self.title = title
    self.onBack = onBack
  }
  
  var body: some View {
    HStack {
      Button(action: onBack) {
        HStack(spacing: 4) {
          Image(systemName: "chevron.left")
          Text("Back")
        }
        .foregroundColor(Color.init(hex: "#F8DC3B"))
      }
      .padding(.leading, 16)
      
      Spacer()
      
      VStack {
        AvatarView(isOnline: true, theme: .default)
          .frame(width: 30, height: 30)
          .padding(.top, 16)
        Spacer()
        Text(title)
          .foregroundStyle(.white)
          .font(.system(size: 17, weight: .bold))
      }
      
      Spacer()
      
      
      
      Color.clear
        .frame(width: 44)
    }
    .frame(height: 84)
    .background(Color.init(hex: "#19191C"))
  }
}

public struct GlobalMediaItem: Identifiable, Equatable {
  public static func == (lhs: GlobalMediaItem, rhs: GlobalMediaItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  public var id: String
  var item: GridItemLayout
  var frame: CGRect
  
  init(id: String = UUID().uuidString, item: GridItemLayout, frame: CGRect) {
    self.id = id
    self.item = item
    self.frame = frame
  }
}

struct ChatView: View {
  @State private var viewModel: ChatFeatureViewModel
  @State private var messageText = ""
  @State private var scrollProxy: ScrollViewProxy?
  
  @FocusState private var isFocused: Bool
  
  @State private var dragOffset: CGFloat = 0
  @State private var showToast = false
  
  @Environment(\.dismiss) private var dismiss
  
  @State var previewItem: GlobalMediaItem? = nil
  @StateObject var previewModel: PreviewViewModel = PreviewViewModel()
  
  @State var _defaultSheetHeightStateForMedia: SheetHeight = .half
  
  @State private var chatTitle = ""
  
  public init(viewModel: ChatFeatureViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        CustomNavigationBar(title: chatTitle, onBack: {
          dismiss()
        })
        
        chatScrollView
          .onAppear {
            previewModel.selectedItem = previewItem
          }
        
        MessageInputView(
          messageText: $messageText,
          isFocused: _isFocused,
          onSendMessage: handleSendMessage,
          onMediaPickerTap: viewModel.toggleMediaPicker
        )
      }
    }
    .onAppear {
      chatTitle = viewModel.chatPreviewModel.name
    }
    .navigationBarHidden(true)
    .universalOverlay(item: $previewItem, content: { item in
      TelegramPreviewOverlay(viewModel: previewItem) { item in
        handleMediaSend(item)
      } onReport: { error, reportReason in
        /// TODO: Lets do real reporting
        showToast = true
      } onDismiss: {
        previewItem = nil
      }
      .onAppear {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    })
    .toast(isPresenting: $showToast, duration: 5.0) {
      AlertToast(
        displayMode: .banner(.pop),
        type: .regular,
        title: "🚓 Klipy moderators will review your report. \nThank you!"
      )
    }
    .contentPushingMediaPicker(
      isPresented: $viewModel.isMediaPickerPresented,
      onSend: handleMediaSend,
      previewItem: $previewItem,
      heightState: $_defaultSheetHeightStateForMedia
    )
    .background(
      Color.init(
        hex: "#19191C"
      )
    )
    .onDisappear {
      viewModel.cleanUp()
    }
  }
  
  private var chatScrollView: some View {
    ScrollViewReader { proxy in
      ScrollView {
        MessagesListView(messages: viewModel.chatPreviewModel.messages, viewModel: viewModel)
      }
      .onAppear {
        scrollProxy = proxy
        scrollToBottom()
      }
      .onChange(of: viewModel.chatPreviewModel.messages.count) { _, _ in
        scrollToBottom()
      }
      .simultaneousGesture(createDragGesture())
      .overlay(ScrollOverlayView(dragOffset: dragOffset, isFocused: isFocused))
    }
  }
  
  private func previewOverlay(for preview: GlobalMediaItem) -> some View {
    ZStack {
      Color.black.opacity(0.85)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
          withAnimation(.easeInOut) {
            previewItem = nil
          }
        }
      
      VStack {
        // Media content
        if preview.item.mp4Media != nil {
          EmptyView()
        } else {
          EmptyView()
        }
        
        // Action buttons
        HStack(spacing: 20) {
          Button(action: {
            // Send the media
            handleMediaSend(preview.item)
            withAnimation {
              previewItem = nil
            }
          }) {
            Text("Send")
              .fontWeight(.bold)
              .padding(.horizontal, 30)
              .padding(.vertical, 12)
              .background(Color(hex: "#F8DC3B"))
              .foregroundColor(.black)
              .cornerRadius(12)
          }
          
          Button(action: {
            withAnimation {
              previewItem = nil
            }
          }) {
            Text("Cancel")
              .fontWeight(.bold)
              .padding(.horizontal, 30)
              .padding(.vertical, 12)
              .background(Color.gray.opacity(0.3))
              .foregroundColor(.white)
              .cornerRadius(12)
          }
        }
        .padding(.bottom, 30)
      }
    }
    .transition(.opacity)
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
    // viewModel.toggleMediaPicker()
    viewModel.sendMediaMessage(item: item)
  }
  
  private func handleSendMessage() {
    viewModel.sendTextMessage(messageText)
    messageText = ""
  }
  
  private func scrollToBottom() {
    withAnimation(.easeOut(duration: 0.1)) {
      scrollProxy?.scrollTo(viewModel.chatPreviewModel.messages.last?.id, anchor: .bottom)
    }
  }
}

struct CustomDetent: CustomPresentationDetent {
  static func height(in context: Context) -> CGFloat? {
    return context.maxDetentValue - 1
  }
}
