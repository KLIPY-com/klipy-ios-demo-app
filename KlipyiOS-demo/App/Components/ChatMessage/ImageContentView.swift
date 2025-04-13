//
//  ImageContentView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

// MARK: - Image Content View
struct ImageContentView: View {
  let mediaItem: GridItemLayout
  
  private var normalizedSize: (width: CGFloat, height: CGFloat) {
      let originalWidth = mediaItem.width * 2
      let originalHeight = mediaItem.height * 2
      
      /// Check if the image needs normalization
      if originalWidth > 200 && originalHeight > 120 {
        let aspectRatio = originalWidth / originalHeight
        
        /// Normalize to smaller size while maintaining aspect ratio
        /// You can adjust these values based on your preference
        let maxWidth: CGFloat = 280
        let maxHeight = maxWidth / aspectRatio
        
        return (width: maxWidth, height: maxHeight)
      }
      
      /// Return original size if normalization isn't needed
      return (width: originalWidth, height: originalHeight)
    }
  
  var body: some View {
    AnimatedImage(url: URL(string: mediaItem.url), isAnimating: .constant(true)) {
      WebImage(url: URL(string: mediaItem.previewUrl))
        .resizable()
        .transition(.fade)
        .aspectRatio(contentMode: .fill)
    }
    .resizable()
    .frame(width: normalizedSize.width, height: normalizedSize.height)
    .aspectRatio(contentMode: .fill)
    .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
  }
}
