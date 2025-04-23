//
//  MasonryGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

/// A view responsible for displaying a masonry grid layout of media items (GIFs, videos, clips, etc.).
/// It arranges rows of media items (as `RowLayout`), provides functionality for loading more items,
/// and allows for user interactions such as sending or previewing an item. It supports features like
/// scrolling, dragging, and dynamic item opacity adjustments for better performance and visual clarity.
struct MasonryGridView: View {

  /// A list of rows containing `GridItemLayout` items, which will be rendered in the grid.
  let rows: [RowLayout]

  /// A flag indicating whether there are more items to load (for pagination purposes).
  let hasNext: Bool

  /// A closure triggered when more items need to be loaded (e.g., when scrolling to the bottom).
  let onLoadMore: () -> Void

  /// A closure triggered when a preview of a media item is loaded.
  let previewLoaded: (GridItemLayout) -> Void

  /// A closure triggered when an item is selected and needs to be sent (e.g., to a preview or other action).
  let onSend: (GridItemLayout) -> Void

  /// A focus state that tracks whether the view is focused (used for keyboard management).
  @FocusState var isFocused: Bool

  /// A state variable that tracks the drag offset of the view (used for hiding the keyboard on drag).
  @State private var dragOffset: CGFloat = 0

  /// A binding for the currently previewed media item.
  @Binding var previewItem: GlobalMediaItem?

  /// The selected category for filtering or rendering different media types.
  var selectedCategory: MediaCategory?

  /// A computed property to determine whether the last row should be drawn.
  /// This helps to decide whether the last row (often containing "recent" items) should be displayed or not.
  var shoudDrawLastRow: Bool {
    guard let category = selectedCategory else {
      return false
    }

    return category.type == .recents
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVStack(spacing: 0) {
        ForEach(rows.indices, id: \.self) { rowIndex in
          RowView.init(
            row: rows[rowIndex],  // Renders each row of items.
            isLastRow: rowIndex == rows.count - 1,  // Checks if it's the last row.
            isFocused: isFocused,  // Determines if the view is focused (keyboard state).
            previewItem: $previewItem,  // Passes the preview item binding for preview management.
            onLoadMore: onLoadMore
          ) { pressedItem in  // Sends the selected item.
            onSend(pressedItem)
          }
          .padding(.bottom, 1)  // Adds padding at the bottom of each row.
          .opacity(shouldDrawView(rowIndex: rowIndex) ? 1 : 0)  // Controls the visibility of the row.
        }
      }
    }
    .allowsHitTesting(previewItem == nil)  // Prevents interactions with the grid when a preview is active.
    .simultaneousGesture(createDragGesture())  // Allows drag gestures for hiding the keyboard.
  }

  /// Determines whether a specific row should be drawn based on the current state and category.
  /// This is useful for controlling whether the last row (containing recent items) is visible.
  /// - Parameter rowIndex: The index of the row being processed.
  /// - Returns: A Boolean value indicating whether the row should be drawn.
  private func shouldDrawView(rowIndex: Int) -> Bool {
    if shoudDrawLastRow {
      return true
    } else {
      if rowIndex != rows.count - 1 {
        return true
      } else {
        return false
      }
    }
  }

  /// Creates a drag gesture that hides the keyboard when the user drags.
  /// The drag gesture is used to detect vertical movement and hide the keyboard when dragging down.
  /// - Returns: A drag gesture that is applied to the grid view.
  private func createDragGesture() -> some Gesture {
    DragGesture()
      .onChanged { value in
        // If the user drags upwards (negative translation), hide the keyboard.
        if value.translation.height < 0 {
          if isFocused {
            hideKeyboard()
          }
        }

        // If the user drags downwards (positive translation), hide the keyboard.
        if value.translation.height > 0 {
          if isFocused {
            hideKeyboard()
          }
        }
      }
  }

  /// Hides the keyboard by resigning the first responder status.
  private func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct OpacityModifier: ViewModifier {
  let rowIndex: Int
  let rowCount: Int

  /// A view modifier used to control the opacity of a row based on its index.
  /// The last row (if `shoudDrawLastRow` is false) will have an opacity of 0, making it invisible.
  /// - Parameter content: The view content to which the modifier is applied.
  func body(content: Content) -> some View {
    content
      .opacity(rowIndex != rowCount - 1 ? 1 : 0)  // Set opacity to 0 for the last row if it's not to be drawn.
  }
}

// This is just an empty modifier when no modification is needed.
struct EmptyModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
  }
}
