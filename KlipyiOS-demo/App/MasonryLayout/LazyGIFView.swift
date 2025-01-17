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
  @State var longPressInProgress: Bool = false
  @State private var itemFrame: CGRect = .zero
  
  init(item: GridItemLayout, previewModel: PreviewViewModel) {
    self.item = item
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
      .onLongPressGesture(minimumDuration: 0.3) {
        previewModel.selectedItem = (item, itemFrame)
      }
    }
  }
}
