//
//  MasonryGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

struct MasonryGridView: View {
  let rows: [RowLayout]
  let hasNext: Bool
  let onLoadMore: () -> Void
  let previewLoaded: (GridItemLayout) -> Void
  let onSend: (GridItemLayout) -> Void
  
  @FocusState var isFocused: Bool
  
  @Binding var previewItem: GlobalMediaItem?
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(rows.indices, id: \.self) { rowIndex in
          RowView.init(
            row: rows[rowIndex],
            isLastRow: rowIndex == rows.count - 1,
            isFocused: isFocused,
            previewItem: $previewItem,
            onLoadMore: onLoadMore) { pressedItem in
              onSend(pressedItem)
            }
            .padding(.bottom, 3)
          /// If !hasNext == true || rowIndex != rows.count - 1 ? 1 : 0
            .opacity(rowIndex != rows.count - 1 ? 1 : 0)
        }
      }
    }
    .allowsHitTesting(previewItem == nil)
  }
}
