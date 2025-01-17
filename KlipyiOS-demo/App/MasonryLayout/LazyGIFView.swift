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
  @State var isAnimating: Bool = true

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
    }
  }
}
