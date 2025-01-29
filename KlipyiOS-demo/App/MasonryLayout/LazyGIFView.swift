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
      }
      .resizable()
      .transition(.fade)
      .playbackRate(2.0)
      .playbackMode(.bounce)
      .aspectRatio(contentMode: .fill)
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
      .onLongPressGesture(minimumDuration: 0.05, perform: {
        impactFeedback.impactOccurred()
        previewModel.selectedItem = (item, itemFrame)
      })
    }
  }
}
