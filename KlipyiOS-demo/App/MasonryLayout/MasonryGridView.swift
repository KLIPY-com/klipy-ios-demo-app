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
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(rows.indices, id: \.self) { rowIndex in
          RowView(row: rows[rowIndex], isLastRow: rowIndex == rows.count - 1, onLoadMore: onLoadMore)
        }
      }
    }
  }
}
