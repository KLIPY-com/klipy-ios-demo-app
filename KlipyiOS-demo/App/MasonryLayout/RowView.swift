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
  let onRowPressed: (GridItemLayout) -> Void
  
  @FocusState var isFocused: Bool
  
  @Binding var previewItem: GlobalMediaItem?
  
  public init(
    row: RowLayout,
    isLastRow: Bool,
    isFocused: Bool,
    previewItem: Binding<GlobalMediaItem?> = .constant(nil),
    onLoadMore: @escaping () -> Void,
    onRowPressed: @escaping (
      GridItemLayout
    ) -> Void
  ) {
    self.row = row
    self.isLastRow = isLastRow
    self.onLoadMore = onLoadMore
    self.onRowPressed = onRowPressed
    self._previewItem = previewItem
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      ForEach(row.items) { item in
        LazyGIFView(
          item: item,
          previewItem: $previewItem,
          onClick: {
            isFocused = false
            onRowPressed(item)
          },
          isFocused: _isFocused
        )
        .frame(width: item.width, height: item.height)
        .offset(x: item.xPosition, y: 0)
        .onAppear {
          if isLastRow && item.id == row.items.last?.id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              withAnimation(.smoothSheet) {
                onLoadMore()
              }
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: row.height, alignment: .leading)
    }
  }
}
