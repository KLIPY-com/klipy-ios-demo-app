//
//  VisibilityChangeModifier.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.03.25.
//


import SwiftUI

struct VisibilityChangeModifier: ViewModifier {
  let isVisible: Bool
  let action: () -> Void
  
  @State private var hasAppeared = false
  
  func body(content: Content) -> some View {
    content
      .onChange(of: isVisible) { _, newValue in
        if newValue && !hasAppeared {
          hasAppeared = true
          action()
        } else if !newValue {
          // Reset so it can trigger again when shown next time
          hasAppeared = false
        }
      }
      .onAppear {
        if isVisible && !hasAppeared {
          hasAppeared = true
          action()
        }
      }
  }
}

struct ContentPushingMediaPickerModifier: ViewModifier {
  @Binding var isPresented: Bool
  let onSend: (GridItemLayout) -> Void
  @Binding var previewItem: GlobalMediaItem?
  let sheetHeight: CGFloat
  
  private let hiddenOffset: CGFloat = 100
  @State private var dragOffset: CGFloat = 0
  
  func body(content: Content) -> some View {
    ZStack(alignment: .bottom) {
      Color.clear
        .frame(height: 0)
        .clipShape(Rectangle())
      
      content
        .offset(y: isPresented ? -sheetHeight : 0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
      
      // Custom Media Picker
      if isPresented {
        Color.black.opacity(0.3)
          .ignoresSafeArea()
          .offset(y: isPresented ? -sheetHeight : 0)
          .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
          .onTapGesture {
            isPresented = false
          }
      }
      
      if isPresented {
        DynamicMediaView(
          onSend: onSend,
          previewItem: $previewItem
        )
        .onVisibilityChange(isVisible: isPresented, perform: {
          print("visibilityh changed")
        })
        .frame(height: sheetHeight)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height + 100)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              if isPresented && gesture.translation.height > 0 {
                dragOffset = gesture.translation.height
              }
            }
            .onEnded { gesture in
              if gesture.translation.height > sheetHeight * 0.2 {
                isPresented = false
              }
              dragOffset = 0
            }
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
      }
    }
  }
}

extension View {
  func contentPushingMediaPicker(
    isPresented: Binding<Bool>,
    onSend: @escaping (GridItemLayout) -> Void,
    previewItem: Binding<GlobalMediaItem?>,
    height: CGFloat = 350
  ) -> some View {
    self.modifier(ContentPushingMediaPickerModifier(
      isPresented: isPresented,
      onSend: onSend,
      previewItem: previewItem,
      sheetHeight: height
    ))
  }
  
  func onVisibilityChange(isVisible: Bool, perform action: @escaping () -> Void) -> some View {
    self.modifier(VisibilityChangeModifier(isVisible: isVisible, action: action))
  }
}