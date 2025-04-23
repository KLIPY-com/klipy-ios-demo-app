//
//  RowView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import Foundation
import SwiftUI

/// A view that represents a row of media items (GIFs, clips, etc.) within a masonry grid layout.
/// Each `RowView` is responsible for rendering the individual items in the row and handling user interactions such as taps.
/// It supports lazy loading of items, dynamic row heights, and pagination for loading more content when the last row is reached.
struct RowView: View {

  /// The layout data for this row, containing the media items and the row height.
  let row: RowLayout

  /// A flag indicating whether this is the last row in the grid.
  /// Used for triggering pagination when the user reaches the end of the list.
  let isLastRow: Bool

  /// A closure triggered to load more items when the user reaches the last row.
  let onLoadMore: () -> Void

  /// A closure triggered when a media item in the row is pressed (clicked).
  /// This is used to pass the pressed item to the parent view for previewing or other actions.
  let onRowPressed: (GridItemLayout) -> Void

  /// A focus state that tracks whether the view is focused (used for keyboard management).
  @FocusState var isFocused: Bool

  /// A binding to the currently previewed media item.
  @Binding var previewItem: GlobalMediaItem?

  /// Custom initializer for `RowView` to pass necessary data and actions to the view.
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
        /// LazyGIFView is used to display each media item in the row (GIF, clip, etc.).
        LazyGIFView(
          item: item,
          previewItem: $previewItem,  // Passes the preview item for interaction.
          onClick: {
            isFocused = false  // Hides the keyboard when an item is clicked.
            onRowPressed(item)  // Passes the clicked item to the parent view.
          },
          isFocused: _isFocused  // Tracks whether the row is focused.
        )
        .frame(width: item.width, height: item.height)  // Sets the size of each media item.
        .offset(x: item.xPosition, y: 0)  // Positions the item horizontally in the row.
        .onAppear {
          // If this is the last row, trigger loading of more items after a delay.
          if isLastRow {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              withAnimation(.smoothSheet) {
                onLoadMore()  // Calls the `onLoadMore` closure to load more items.
              }
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: row.height, alignment: .leading)  // Sets the row's frame to fit its height.
    }
  }
}
