//
//  MasonryLayoutCalculator.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation
import UIKit

/// This class is responsible for calculating a masonry-style layout for media items (GIFs, clips, ads, etc.).
/// It handles dynamic resizing, optimal row fitting, and intelligent ad integration.
/// The result is a layout where rows fit tightly within the container width while preserving aspect ratios
/// and visual balance across different media types.
class MasonryLayoutCalculator {

    // MARK: - Configuration Properties

    /// The total width of the container where items will be laid out (typically screen width).
    private let containerWidth: CGFloat

    /// The spacing (in points) between items horizontally.
    /// We recommend using the same padding in MasonryGridView (bottom) and in LazyGifView for a consistent visual experience.
    private let gap: CGFloat

    /// The minimum allowed width for a non-ad media item.
    private let minGifWidth: CGFloat

    /// The minimum allowed height for any row.
    private let minHeight: CGFloat

    /// The maximum allowed height for any row.
    private let maxHeight: CGFloat

    /// The maximum number of items allowed per row (helps with readability and ad placement).
    private let maxGifsPerRow: Int

    // MARK: - Initializer

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

    // MARK: - Helper: Extract dimensions and media URL based on media type

    /// Returns original dimensions and media URL for a given media item depending on its type.
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

    // MARK: - Core Logic: Calculate the optimal layout for a row

    /// Finds the best combination of items for a single row based on resizing, aspect ratio, and available width.
    /// Also handles special rules for ad positioning and scaling.
    private func calculateOptimalRow(_ possibleItems: [GridItemLayout], _ itemMinWidth: Int, _ adMaxResizePercent: Int) -> ([GridItemLayout], CGFloat) {
        var minimumChange = CGFloat.greatestFiniteMagnitude
        var currentRow: [GridItemLayout] = []
        var optimalHeight: CGFloat = 0

        var currentMinHeight = minHeight
        var currentMaxHeight = maxHeight

        // Check if an ad exists in the row, and adjust height rules accordingly.
        let adIndex = possibleItems.firstIndex { $0.type == "ad" }
        if let adIndex = adIndex, adIndex > 1 {
            // If ad is after index 1 (i.e., 3rd+ position), reduce row to just 2 items
            let items = Array(possibleItems.prefix(2))
            return calculateOptimalRow(items, itemMinWidth, adMaxResizePercent)
        } else if let adIndex = adIndex {
            // If ad exists early, use its height as fixed for the row
            currentMinHeight = possibleItems[adIndex].height
            currentMaxHeight = possibleItems[adIndex].height
        }

        // Try every height from min to max and find best-fit row with least leftover width
        for height in Int(currentMinHeight)...Int(currentMaxHeight) {
            var itemsInRow: [GridItemLayout] = []

            for item in possibleItems {
                var newItem = item
                if item.type == "ad" {
                    // Ads are not resized
                    newItem.newWidth = item.width
                } else {
                    // Resize maintaining aspect ratio
                    let newWidth = round((item.originalWidth * CGFloat(height)) / item.originalHeight)
                    newItem.newWidth = newWidth
                }
                itemsInRow.append(newItem)

                // Compute row total width including gaps
                let totalWidth = itemsInRow.reduce(0) { $0 + $1.newWidth } + CGFloat(itemsInRow.count - 1) * gap
                let change = containerWidth - totalWidth

                // Pick the row closest to exact fit (or if current row only had 1 item)
                if abs(change) < abs(minimumChange) || (currentRow.count == 1 && itemsInRow.count != 1) {
                    if itemsInRow.count != 1 || currentRow.isEmpty {
                        minimumChange = change
                        currentRow = itemsInRow
                        optimalHeight = CGFloat(height)
                    }
                }
            }
        }

        // Final adjustment: spread leftover pixels across non-ad items to perfectly fill width
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

        // MARK: - Ad Resize Logic (only if row contains ad and non-ads were too small)

        if let adIndex = adIndex, nonAdItems.count != currentRow.count {
            let itemsBelowMin = nonAdItems.filter { $0.width < CGFloat(itemMinWidth) }

            if !itemsBelowMin.isEmpty {
                // Force small items to min width
                for i in 0..<currentRow.count {
                    if currentRow[i].type != "ad", currentRow[i].width < CGFloat(itemMinWidth) {
                        currentRow[i].width = CGFloat(itemMinWidth)
                    }
                }

                // Recalculate row width after forcing min width
                let newRowWidth = currentRow.reduce(0) { $0 + $1.width } + CGFloat(currentRow.count - 1) * gap

                if newRowWidth > containerWidth {
                    var adItem = currentRow[adIndex]

                    // Calculate how much we are allowed to shrink the ad
                    let minAdWidth = adItem.width * (100 - CGFloat(adMaxResizePercent)) / 100
                    var resizedAdWidth = adItem.width - (newRowWidth - containerWidth)

                    if resizedAdWidth < minAdWidth {
                        // Spread some of the excess to other items again if ad hit minimum size
                        let adWidthDifference = minAdWidth - resizedAdWidth
                        for i in 0..<currentRow.count {
                            if currentRow[i].type != "ad", currentRow[i].width == CGFloat(itemMinWidth) {
                                currentRow[i].width -= adWidthDifference / CGFloat(itemsBelowMin.count)
                            }
                        }
                        resizedAdWidth = minAdWidth
                    }

                    // Apply ad resize and update others to match new row height
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

    // MARK: - Public: Generate full layout of multiple rows

    /// Divides the input items into rows, computes size and position for each media item.
    /// Handles ad placement, resizing, and spacing between items.
    func createRows(from items: [MediaDomainModel], withMeta: GridMeta) -> [RowLayout] {
        var rows: [RowLayout] = []
        var nextItem = 0

        while nextItem < items.count {
            // Take maxGifsPerRow items to try building the next row
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

            // Calculate best row from subset
            let (rowItems, rowHeight) = calculateOptimalRow(possibleLayoutItems, withMeta.adMaxResizePercent, withMeta.itemMinWidth)
            rows.append(RowLayout(items: rowItems, height: rowHeight))
            nextItem += rowItems.count
        }

        // Final pass: assign x/y positions for rendering
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
