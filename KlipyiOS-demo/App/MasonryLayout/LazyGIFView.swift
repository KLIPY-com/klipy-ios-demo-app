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
  
  var onClick: (() -> Void)
  
  init(item: GridItemLayout, previewModel: PreviewViewModel, onClick: @escaping () -> Void) {
    self.item = item
    self.onClick = onClick
    _previewModel = StateObject(wrappedValue: previewModel)
  }
  
  var body: some View {
    Group {
      AnimatedImage(url: URL(string: item.url), isAnimating: .constant(true)) {
        WebImage(url: URL(string: item.previewUrl))
          .resizable()
          .transition(.fade)
          .aspectRatio(contentMode: .fill)
          .frame(width: itemFrame.width, height: itemFrame.height)
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
            state = true
          }
          .onChanged { _ in
            if !isPressed {
              isPressed = true
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
