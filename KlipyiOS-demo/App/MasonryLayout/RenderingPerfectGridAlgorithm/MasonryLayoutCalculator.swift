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
        minGifWidth: CGFloat = 50,
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
    
    private func getDimensions(from item: MediaDomainModel) -> (width: CGFloat, height: CGFloat, url: String) {
        switch item.type {
        case .clips:
            guard let file = item.singleFile?.gif else {
                return (0, 0, "")
            }
            
            return (CGFloat(file.width), CGFloat(file.height), file.url)
        case .gifs, .stickers:
            guard let file = item.xs?.gif else {
                return (0, 0, "")
            }
          return (CGFloat(file.width), CGFloat(file.height), file.url)
        case .ad:
          guard let file = item.addContentProperties else {
            return (0, 0, "")
          }
          return (CGFloat(file.width), CGFloat(file.height), file.content)
        }
    }
    
    private func calculateOptimalRow(_ possibleItems: [GridItemLayout]) -> ([GridItemLayout], CGFloat) {
        var minimumChange = CGFloat.greatestFiniteMagnitude
        var currentRow: [GridItemLayout] = []
        var optimalHeight: CGFloat = 0
        
        var currentMinHeight = minHeight
        var currentMaxHeight = maxHeight
        
        // Check for ads and adjust height constraints if needed
        let adIndex = possibleItems.firstIndex { $0.type == "ad" }
        if let adIndex = adIndex, adIndex > 1 {
            // Limit to 2 items if ad is beyond position 1
            let items = Array(possibleItems.prefix(2))
            return calculateOptimalRow(items)
        } else if let adIndex = adIndex {
            // If ad exists, use its height as fixed constraint
            currentMinHeight = possibleItems[adIndex].height
            currentMaxHeight = possibleItems[adIndex].height
        }
        
        for height in Int(currentMinHeight)...Int(currentMaxHeight) {
            var itemsInRow: [GridItemLayout] = []
            
            for item in possibleItems {
                var newItem = item
                if item.type == "ad" {
                    newItem.newWidth = item.width
                } else {
                    let newWidth = round((item.originalWidth * CGFloat(height)) / item.originalHeight)
                    newItem.newWidth = newWidth
                }
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
        
        // Adjust final widths
        let nonAdItems = currentRow.filter { $0.type != "ad" }
        let adjustmentPerItem = nonAdItems.isEmpty ? 0 : minimumChange / CGFloat(nonAdItems.count)
        
        for i in 0..<currentRow.count {
            if currentRow[i].type == "ad" {
                currentRow[i].width = currentRow[i].newWidth
            } else {
                currentRow[i].width = currentRow[i].newWidth + adjustmentPerItem
            }
            currentRow[i].height = optimalHeight
        }
        
        return (currentRow, optimalHeight)
    }
    
    func createRows(from items: [MediaDomainModel]) -> [RowLayout] {
        var rows: [RowLayout] = []
        var nextItem = 0
        
        while nextItem < items.count {
            let possibleItems = Array(items[nextItem..<min(nextItem + maxGifsPerRow, items.count)])
            
            let possibleLayoutItems = possibleItems.map { item -> GridItemLayout in
                let dimensions = getDimensions(from: item)
                return GridItemLayout(
                    id: Int64(item.id),
                    url: dimensions.url,
                    highQualityUrl: item.md?.gif.url ?? "",
                    mp4Media: item.singleFile,
                    previewUrl: item.blurPreview ?? "",
                    width: dimensions.width,
                    height: dimensions.height,
                    originalWidth: dimensions.width,
                    originalHeight: dimensions.height,
                    type: item.type.rawValue
                )
            }
            
            let (rowItems, rowHeight) = calculateOptimalRow(possibleLayoutItems)
            rows.append(RowLayout(items: rowItems, height: rowHeight))
            nextItem += rowItems.count
        }

        // Calculate positions
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
}
