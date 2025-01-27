//
//  RowView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import SwiftUI
import Foundation

struct RowView: View {
  let row: RowLayout
  let isLastRow: Bool
  let onLoadMore: () -> Void
  let previewModel: PreviewViewModel
  let onRowPressed: (GridItemLayout) -> Void
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      ForEach(row.items) { item in
        LazyGIFView(
          item: item,
          previewModel: previewModel,
          onClick: {
            onRowPressed(item)
          }
        )
        .frame(width: item.width, height: item.height)
        .offset(x: item.xPosition, y: 0)
        .onAppear {
          if isLastRow && item.id == row.items.last?.id {
            onLoadMore()
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: row.height, alignment: .leading)
  }
}
