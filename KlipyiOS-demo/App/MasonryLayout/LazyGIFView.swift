//  LazyGIFView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import SwiftUI
import Foundation
import GIFImage

// TODO: Caching Mechanism

struct LazyGIFView: View {
  let item: GridItemLayout

  @State private var gifImage: GIFImage?
  @State private var loadingTask: Task<Void, Never>?
  
  private var color: Color {
    let colors: [Color] = [.blue, .red, .green, .purple, .orange]
    let index = Int(item.id) % colors.count
    return colors[index]
  }
  
  var body: some View {
    Group {
      if let image = gifImage {
        image
          .aspectRatio(contentMode: .fill)
      } else {
        Color.gray.opacity(0.3)
          .onAppear {
            loadImage()
          }
      }
    }
  }
  
  private func loadImage() {
    loadingTask?.cancel()
    
    loadingTask = Task {
      let image = await GIFLoader.shared.loadGIF(from: item.url)
      
      if !Task.isCancelled {
        await MainActor.run {
          self.gifImage = image
        }
      }
    }
  }
}
