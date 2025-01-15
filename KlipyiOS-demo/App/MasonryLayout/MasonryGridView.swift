//
//  MasonryGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI
import GIFImage

struct MasonryGridView: View {
  let rows: [RowLayout]
  let onLoadMore: () -> Void
  
  private var totalHeight: CGFloat {
    guard let lastRow = rows.last else { return 0 }
    return lastRow.items.first?.yPosition ?? 0 + lastRow.height
  }
  
  var body: some View {
    ScrollView {
      ZStack(alignment: .topLeading) {
        Color.clear
          .frame(height: totalHeight)
        ForEach(rows.indices, id: \.self) { rowIndex in
          ForEach(rows[rowIndex].items) { item in
            GIFImage(source: .remoteURL(URL(string: item.url)!), frameRate: .dynamic)
              .frame(width: item.width, height: item.height)
              .position(x: item.xPosition + item.width/2,
                        y: item.yPosition + item.height/2)
              .onAppear {
                if rowIndex == rows.count - 1 &&
                    item.id == rows[rowIndex].items.last?.id {
                  onLoadMore()
                }
              }
          }
        }
      }
      .frame(maxWidth: .infinity)
    }
  }
}
