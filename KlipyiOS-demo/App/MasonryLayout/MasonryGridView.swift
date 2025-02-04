//
//  MasonryGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

struct MasonryGridView: View {
  let rows: [RowLayout]
  let onLoadMore: () -> Void
  
  let onSend: (GridItemLayout) -> Void
  let onReport: (String, ReportReason) -> Void
  
  @FocusState var isFocused: Bool
  
  @StateObject private var previewModel = PreviewViewModel()
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(rows.indices, id: \.self) { rowIndex in
          RowView(
            row: rows[rowIndex],
            isLastRow: rowIndex == rows.count - 1,
            onLoadMore: onLoadMore,
            previewModel: previewModel,
            isFocused: _isFocused) { pressedItem in
              onSend(pressedItem)
            }
            .padding(.bottom, 3)
        }
      }
    }
    .allowsHitTesting(previewModel.selectedItem == nil)
    
    if previewModel.selectedItem != nil {
      TelegramPreviewOverlay(
        viewModel: previewModel,
        onSend: { url in
          onSend(url)
        },
        onReport: { url, reportReason in
          onReport(url, reportReason)
        }
      ) {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            previewModel.selectedItem = nil
            previewModel.isDragging = false
            previewModel.dragOffset = .zero
            previewModel.dragScale = 1
          }
        }
    }
  }
}
