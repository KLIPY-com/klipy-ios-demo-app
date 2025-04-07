//
//  ContentPushingMediaPickerModifier.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.03.25.
//


import SwiftUI

enum SheetHeight {
  case half
  case full
  
  func value(for screen: CGRect = UIScreen.main.bounds) -> CGFloat {
    switch self {
    case .half:
      return screen.height * 0.5
    case .full:
      return screen.height * 0.8
    }
  }
}

/// DragOffset ზე ჩამოვიდეს .half სტეიტზე
/// და ზევით დავამატოთ native sheet ის ვიუ რომ მიხვდეს უზერი რომ ჩამოსქროლვა შეიძლება

struct ContentPushingMediaPickerModifier: ViewModifier {
  @Binding var isPresented: Bool
  let onSend: (GridItemLayout) -> Void
  @Binding var previewItem: GlobalMediaItem?
  
  private let hiddenOffset: CGFloat = 100
  @State private var dragOffset: CGFloat = 0
  
  @Binding var heightState: SheetHeight
  @State private var currentHeight: CGFloat
  
  @State private var heightVersion: Int = 0
  @State private var keyboardHeight: CGFloat = 0
  
  private let keyboardWillShowPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
   private let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
  
  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        if isPresented && gesture.translation.height > 0 {
          dragOffset = gesture.translation.height
        }
      }
      .onEnded { gesture in
        if gesture.translation.height > currentHeight * 0.2 {
          heightState = .half
        }
        dragOffset = 0
      }
  }
  
  init(
    isPresented: Binding<Bool>,
    onSend: @escaping (GridItemLayout) -> Void,
    previewItem: Binding<GlobalMediaItem?>,
    heightState: Binding<SheetHeight>
  ) {
    self._isPresented = isPresented
    self.onSend = onSend
    self._previewItem = previewItem
    self._heightState = heightState
    self._currentHeight = State(initialValue: heightState.wrappedValue.value())
  }
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottom) {
      Color.clear
        .frame(height: 0)
        .clipShape(Rectangle())
      
      content
        .offset(y: isPresented ? -min(currentHeight, UIScreen.main.bounds.height - keyboardHeight - 44) : 0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
      
      if isPresented {
        Color.black.opacity(0.3)
          .ignoresSafeArea()
          .offset(y: isPresented ? -min(currentHeight, UIScreen.main.bounds.height - keyboardHeight - 44) : 0)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
          .onTapGesture {
            isPresented = false
          }
      }
      
      if isPresented {
        VStack {
          if heightState == .full {
            SheetHandleIndicator()
              .contentShape(Rectangle())
              .gesture(dragGesture)
              .onTapGesture(count: 2) {
                withAnimation {
                  heightState = heightState == .half ? .full : .half
                }
              }
          }

          DynamicMediaViewWrapper(
            onSend: onSend,
            previewItem: $previewItem,
            sheetHeight: $heightState,
            heightVersion: heightVersion
          )
          .gesture(dragGesture)
          .frame(height: currentHeight)
          .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
          .offset(y: isPresented ? 0 : UIScreen.main.bounds.height + 100)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: keyboardHeight)
        }
      }
    }
    .onChange(of: heightState) { _, newHeightState in
      withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
        currentHeight = newHeightState.value()
        heightVersion += 1
      }
    }
    .onReceive(keyboardWillShowPublisher) { notification in
      if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
        keyboardHeight = keyboardFrame.height
      }
    }
    .onReceive(keyboardWillHidePublisher) { _ in
      keyboardHeight = 0
    }
  }
}

extension View {
  func contentPushingMediaPicker(
    isPresented: Binding<Bool>,
    onSend: @escaping (GridItemLayout) -> Void,
    previewItem: Binding<GlobalMediaItem?>,
    heightState: Binding<SheetHeight>
  ) -> some View {
    self.modifier(ContentPushingMediaPickerModifier(
      isPresented: isPresented,
      onSend: onSend,
      previewItem: previewItem,
      heightState: heightState
    ))
  }
}

struct DynamicMediaViewWrapper: View {
  let onSend: (GridItemLayout) -> Void
  @Binding var previewItem: GlobalMediaItem?
  @Binding var sheetHeight: SheetHeight
  let heightVersion: Int
  
  var body: some View {
    DynamicMediaView(
      onSend: { mediaItem in
        onSend(mediaItem)
        if sheetHeight == .full {
          sheetHeight = .half
        }
      },
      previewItem: $previewItem,
      sheetHeight: $sheetHeight
    )
    .id("mediaView-\(heightVersion)-\(sheetHeight)")
  }
}

struct SheetHandleIndicator: View {
    var body: some View {
        // This VStack creates a larger interactive area
        VStack(spacing: 0) {
            // Top padding creates space above the handle
            Spacer()
                .frame(height: 8)
            
            // The visible handle indicator
            Rectangle()
                .fill(Color(UIColor.systemGray3))
                .frame(width: 40, height: 5)
                .cornerRadius(2.5)
            
            // Bottom padding creates space below the handle
            Spacer()
                .frame(height: 8)
        }
        // Make the entire area (including padding) tappable/draggable
        .frame(width: 60, height: 30)
        .contentShape(Rectangle())
        // Debug option - uncomment to see the touch area
        // .background(Color.red.opacity(0.2))
    }
}
