//
//  MasonryLayoutCalculator.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation
import UIKit

class MasonryLayoutCalculator {
  private let containerWidth: CGFloat
  private let gap: CGFloat
  private let minGifWidth: CGFloat
  private let minHeight: CGFloat
  private let maxHeight: CGFloat
  private let maxGifsPerRow: Int
  
  init(
    containerWidth: CGFloat = UIScreen.main.bounds.width,
    gap: CGFloat = 3,
    minGifWidth: CGFloat = 60,
    minHeight: CGFloat = 50,
    maxHeight: CGFloat = 180,
    maxGifsPerRow: Int = 4
  ) {
    self.containerWidth = containerWidth
    self.gap = gap
    self.minGifWidth = minGifWidth
    self.minHeight = minHeight
    self.maxHeight = maxHeight
    self.maxGifsPerRow = maxGifsPerRow
  }
  
  func createRows(from items: [GifItem]) -> [RowLayout] {
    var rows: [RowLayout] = []
    var nextItem = 0
    
    while nextItem < items.count {
      let possibleItems = Array(items[nextItem..<min(nextItem + maxGifsPerRow, items.count)])
      
      let possibleLayoutItems = possibleItems.map { gif -> GridItemLayout in
        let dimensions = gif.file.xs.webp
        return GridItemLayout(
          id: Int64(gif.id),
          url: dimensions.url,
          width: CGFloat(dimensions.width),
          height: CGFloat(dimensions.height),
          originalWidth: CGFloat(dimensions.width),
          originalHeight: CGFloat(dimensions.height),
          type: gif.type.rawValue
        )
      }

      let (rowItems, rowHeight) = calculateOptimalRow(possibleLayoutItems)
      rows.append(RowLayout(items: rowItems, height: rowHeight))
      nextItem += rowItems.count
    }

    var currentY: CGFloat = 0
    for rowIndex in 0..<rows.count {
      var currentX: CGFloat = 0
      for itemIndex in 0..<rows[rowIndex].items.count {
        rows[rowIndex].items[itemIndex].xPosition = currentX
        rows[rowIndex].items[itemIndex].yPosition = currentY
        currentX += rows[rowIndex].items[itemIndex].width + gap
      }
      currentY += rows[rowIndex].height + gap
    }
    
    return rows
  }
  
  private func calculateOptimalRow(_ possibleItems: [GridItemLayout]) -> ([GridItemLayout], CGFloat) {
    var minimumChange = CGFloat.greatestFiniteMagnitude
    var currentRow: [GridItemLayout] = []
    var optimalHeight: CGFloat = 0
    
    for height in Int(minHeight)...Int(maxHeight) {
      var itemsInRow: [GridItemLayout] = []
  
      for item in possibleItems {
        var newItem = item
        let newWidth = round((item.originalWidth * CGFloat(height)) / item.originalHeight)
        newItem.newWidth = newWidth
        itemsInRow.append(newItem)
        
        let totalWidth = itemsInRow.reduce(0) { $0 + $1.newWidth } + CGFloat(itemsInRow.count - 1) * gap
        let change = containerWidth - totalWidth
        
        if abs(change) < abs(minimumChange) || (currentRow.count == 1 && itemsInRow.count != 1) {
          if itemsInRow.count != 1 || currentRow.isEmpty {
            minimumChange = change
            currentRow = itemsInRow
            optimalHeight = CGFloat(height)
          }
        }
      }
    }
    
    let adjustmentPerItem = currentRow.count > 1 ? minimumChange / CGFloat(currentRow.count - 1) : 0
    for i in 0..<currentRow.count {
      currentRow[i].width = currentRow[i].newWidth + adjustmentPerItem
      currentRow[i].height = optimalHeight
    }
    
    return (currentRow, optimalHeight)
  }
}
