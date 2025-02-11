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
  let onReport: (GridItemLayout, String, ReportReason) -> Void
  
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
              /// If !hasNext == true || rowIndex != rows.count - 1 ? 1 : 0
              .opacity(rowIndex != rows.count - 1 ? 1 : 0)
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
          guard let previewModel = previewModel.selectedItem?.item else { return }
          onReport(previewModel, url, reportReason)
        }
      ) {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            previewModel.selectedItem = nil
            previewModel.isDragging = false
            previewModel.dragOffset = .zero
            previewModel.dragScale = 1
          }
      }
      .onAppear {
        guard let previewModel = previewModel.selectedItem?.item else { return }
        previewLoaded(previewModel)
      }
    }
  }
}
