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
        gap: CGFloat = 1,
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
    
    private func calculateOptimalRow(_ possibleItems: [GridItemLayout], _ itemMinWidth: Int, _ adMaxResizePercent: Int) -> ([GridItemLayout], CGFloat) {
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
            return calculateOptimalRow(items, itemMinWidth, adMaxResizePercent)
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
        
        // Scale advertisement if it's necessary + possible depending on itemMinWidth and adMaxResizePercent
        if let adIndex = adIndex, nonAdItems.count != currentRow.count {
            let itemsBelowMin = nonAdItems.filter { $0.width < CGFloat(itemMinWidth) }

            if !itemsBelowMin.isEmpty {
                // Set items to itemMinWidth
                for i in 0..<currentRow.count {
                    if currentRow[i].type != "ad", currentRow[i].width < CGFloat(itemMinWidth) {
                        currentRow[i].width = CGFloat(itemMinWidth)
                    }
                }

                // Recalculate total row width
                let newRowWidth = currentRow.reduce(0) { $0 + $1.width } + CGFloat(currentRow.count - 1) * gap

                if newRowWidth > containerWidth {
                    var adItem = currentRow[adIndex]
                    let minAdWidth = adItem.width * (100 - CGFloat(adMaxResizePercent)) / 100
                    var resizedAdWidth = adItem.width - (newRowWidth - containerWidth)

                    if resizedAdWidth < minAdWidth {
                        let adWidthDifference = minAdWidth - resizedAdWidth
                        for i in 0..<currentRow.count {
                            if currentRow[i].type != "ad", currentRow[i].width == CGFloat(itemMinWidth) {
                                currentRow[i].width -= adWidthDifference / CGFloat(itemsBelowMin.count)
                            }
                        }
                        resizedAdWidth = minAdWidth
                    }

                    let scaleFactor = resizedAdWidth / adItem.width
                    adItem.height *= scaleFactor
                    adItem.width = resizedAdWidth
                    adItem.newWidth = resizedAdWidth
                    currentRow[adIndex] = adItem

                    for i in 0..<currentRow.count {
                        if currentRow[i].type != "ad" {
                            currentRow[i].height = adItem.height
                        }
                    }
                    optimalHeight = adItem.height
                }
            }
        }

        return (currentRow, optimalHeight)
    }
    
  func createRows(from items: [MediaDomainModel], withMeta: GridMeta) -> [RowLayout] {
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
                    type: item.type.rawValue,
                    title: item.title,
                    slug: item.slug
                )
            }
            
            let (rowItems, rowHeight) = calculateOptimalRow(possibleLayoutItems, withMeta.adMaxResizePercent, withMeta.itemMinWidth)
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
