//
//  PreviewViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import SwiftUI
import Foundation
import SDWebImage
import SDWebImageSwiftUI

struct TelegramPreviewOverlay: View {
  @ObservedObject var viewModel: PreviewViewModel
  let onDismiss: () -> Void
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        if let selectedItem = viewModel.selectedItem {
          let screenSize = geometry.size
  
          let targetSize = calculateTargetSize(
            originalSize: CGSize(
              width: selectedItem.item.width,
              height: selectedItem.item.height
            ),
            screenSize: screenSize
          )
          
          ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
              .opacity({
                if viewModel.isDragging {
                  let dragPercentage = abs(viewModel.dragOffset.height) / 300
                  return 0.8 * (1.0 - dragPercentage)
                }
                return 0.8
              }())
              .ignoresSafeArea()
              .onTapGesture {
                onDismiss()
              }
            
            VStack(alignment: .leading, spacing: 8) {
              AnimatedImage(url: URL(string: selectedItem.item.url))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: targetSize.width, height: targetSize.height)
                .offset(
                  x: viewModel.isDragging ? viewModel.dragOffset.width : 0,
                  y: viewModel.isDragging ? viewModel.dragOffset.height : 0
                )
                .scaleEffect(viewModel.dragScale)
                .gesture(
                  DragGesture()
                    .onChanged { value in
                      viewModel.isDragging = true
                      viewModel.dragOffset = value.translation
                      
                      let dragDistance = abs(value.translation.height)
                      viewModel.dragScale = max(0.7, min(1, 1 - (dragDistance / 1000)))
                    }
                    .onEnded { value in
                      let dragDistance = abs(value.translation.height)
                      if dragDistance > 100 {
                        onDismiss()
                      } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                          viewModel.isDragging = false
                          viewModel.dragOffset = .zero
                          viewModel.dragScale = 1
                        }
                      }
                    }
                )
                .onAppear {
                  playHapticFeedback()
                }
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
            }
          }
        }
      }
    }
  }
  
  func playHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
    impactFeedback.prepare()
    impactFeedback.impactOccurred()
  }
  
  private func calculateTargetSize(originalSize: CGSize, screenSize: CGSize) -> CGSize {
    let maxWidth = screenSize.width * 0.9
    let maxHeight = screenSize.height * 0.7
    
    let widthRatio = maxWidth / originalSize.width
    let heightRatio = maxHeight / originalSize.height
    
    let scale = min(widthRatio, heightRatio)
    
    return CGSize(
      width: originalSize.width * scale,
      height: originalSize.height * scale
    )
  }
}
