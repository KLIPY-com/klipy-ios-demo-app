//  LazyGIFView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import SwiftUI
import Foundation
import SDWebImage
import SDWebImageSwiftUI

struct LazyGIFView: View {
  let item: GridItemLayout
  
  @StateObject private var previewModel: PreviewViewModel
  @State private var isPressed: Bool = false
  @State private var timer: Timer?
  @GestureState private var isPressing: Bool = false
  
  
  
  @State var isAnimating: Bool = true
  @State var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
  @State var clickFeedback = UIImpactFeedbackGenerator(style: .heavy)
  @State var longPressInProgress: Bool = false
  @State private var itemFrame: CGRect = .zero
  
  @FocusState var isFocused: Bool
  
  var onClick: (() -> Void)
  
  init(item: GridItemLayout, previewModel: PreviewViewModel, onClick: @escaping () -> Void, isFocused: FocusState<Bool>) {
    self.item = item
    self.onClick = onClick
    self._isFocused = isFocused
    _previewModel = StateObject(wrappedValue: previewModel)
  }
  
  var body: some View {
    Group {
      AnimatedImage(url: URL(string: item.url), isAnimating: .constant(true)) {
          if let image = Image.fromBase64(item.previewUrl) {
              image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: item.width, height: item.height)
          }
      }
      .resizable()
      .transition(.fade)
      .playbackRate(1.0)
      .playbackMode(.bounce)
      .aspectRatio(contentMode: .fill)
      .scaleEffect(isPressing ? 0.8 : 1.0)
      .animation(.spring(response: 0.9, dampingFraction: 0.9), value: isPressing)
      .overlay(GeometryReader { geo -> Color in
        DispatchQueue.main.async {
          itemFrame = geo.frame(in: .global)
        }
        return Color.clear
      })
      .onTapGesture {
        isFocused = false

        if item.mp4Media != nil {
          impactFeedback.impactOccurred()
          previewModel.selectedItem = (item, itemFrame)
        } else {
          clickFeedback.impactOccurred()
          onClick()
        }
      }
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .updating($isPressing) { _, state, _ in
            isFocused = false
            state = true
          }
          .onChanged { _ in
            isFocused = false

            if !isPressed {
              isPressed = false
              timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                impactFeedback.impactOccurred()
                previewModel.selectedItem = (item, itemFrame)
                withAnimation {
                  isPressed = false
                }
              }
            }
          }
          .onEnded { _ in
            isFocused = false
            timer?.invalidate()
            timer = nil
            withAnimation {
              isPressed = false
            }
          }
      )
    }
  }
}


extension Image {
    /// Creates an Image from a base64 string using SDWebImage
    /// - Parameter base64String: The base64 encoded image string
    /// - Returns: An Image view, or nil if the string couldn't be converted
    static func fromBase64(_ string: String) -> Image? {
        let base64String = string.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")

        guard let data = Data(base64Encoded: base64String),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}

