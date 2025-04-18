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
  @State private var dragOffset: CGFloat = 0
  
  @Binding var previewItem: GlobalMediaItem?
  var selectedCategory: MediaCategory?
  
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
            row: rows[rowIndex],
            isLastRow: rowIndex == rows.count - 1,
            isFocused: isFocused,
            previewItem: $previewItem,
            onLoadMore: onLoadMore) { pressedItem in
              onSend(pressedItem)
            }
            .padding(.bottom, 1)
            .opacity(shouldDrawView(rowIndex: rowIndex) ? 1 : 0)
        }
      }
    }
    .allowsHitTesting(previewItem == nil)
    .simultaneousGesture(createDragGesture())
  }
  
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
  
  private func createDragGesture() -> some Gesture {
      DragGesture()
      .onChanged { value in
        if value.translation.height < 0 {
          if isFocused {
            hideKeyboard()
          }
        }
        
        if value.translation.height > 0 {
          if isFocused {
            hideKeyboard()
          }
        }
      }
    }
  
  private func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct OpacityModifier: ViewModifier {
  let rowIndex: Int
  let rowCount: Int
  
  func body(content: Content) -> some View {
    content
      .opacity(rowIndex != rowCount - 1 ? 1 : 0)
  }
}

// This is just an empty modifier when no modification is needed
struct EmptyModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
  }
}
