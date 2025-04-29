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
///
/// The layout calculation ensures that media items (such as GIFs, clips, or ads) are displayed with respect to
/// their aspect ratios, spacing, and rows are dynamically adjusted to fill the screen width optimally. Ads are treated
/// specially and are integrated intelligently into the layout, either by resizing or adjusting row configurations.
class MasonryLayoutCalculator {

  // MARK: - Configuration Properties

  /// The total width of the container where items will be laid out (typically screen width).
  /// The containerWidth is used as the base width for calculating the optimal layout.
  /// This helps in ensuring that the masonry layout adapts to different screen sizes (e.g., iPhone, iPad).
  private let containerWidth: CGFloat

  /// The spacing (in points) between items horizontally.
  /// This spacing is applied to the space between each item in the row.
  /// A consistent horizontalSpacing ensures a clean, consistent layout with uniform gaps between media items.
  /// It is crucial to match this value with the corresponding value in other view components (e.g., MasonryGridView) for visual consistency.
  private let horizontalSpacing: CGFloat

  /// The minimum allowed height for any row.
  /// This value represents the smallest possible height a row can have when calculating the layout.
  /// It is used to ensure that each row has a reasonable minimum height for media items to be visible clearly.
  private let minRowHeight: CGFloat

  /// The maximum allowed height for any row.
  /// This value represents the tallest possible height a row can have. This helps in ensuring that the media items
  /// do not take up too much vertical space in the layout, ensuring a balanced presentation across different screen sizes.
  private let maxRowHeight: CGFloat

  /// The maximum number of items allowed per row (helps with readability and ad placement).
  /// This limits the number of items that can appear in a single row, ensuring that rows don’t become too wide
  /// and remain visually manageable. This value also helps in creating space for ad items without crowding the media items.
  private let maxItemsPerRow: Int

  // MARK: - Initializer

  /// Initializes the MasonryLayoutCalculator with configurable parameters for layout calculation.
  ///
  /// - Parameters:
  ///   - containerWidth: The total width of the container (e.g., screen width). Defaults to the screen's width.
  ///   - horizontalSpacing: Horizontal spacing between items. Defaults to 1 point.
  ///   - minRowHeight: The minimum allowed height for any row. Defaults to 50 points.
  ///   - maxRowHeight: The maximum allowed height for any row. Defaults to 180 points.
  ///   - maxItemsPerRow: The maximum number of items per row. Defaults to 4 items per row.
  init(
    containerWidth: CGFloat = UIScreen.main.bounds.width,
    horizontalSpacing: CGFloat = 1,
    minRowHeight: CGFloat = 50,
    maxRowHeight: CGFloat = 180,
    maxItemsPerRow: Int = 4
  ) {
    self.containerWidth = containerWidth
    self.horizontalSpacing = horizontalSpacing
    self.minRowHeight = minRowHeight
    self.maxRowHeight = maxRowHeight
    self.maxItemsPerRow = maxItemsPerRow
  }

  // MARK: - Helper: Extract dimensions and media URL based on media type

  /// Extracts and returns the original dimensions (width, height) and the media URL for a given media item.
  /// The dimensions are fetched based on the type of media (clips, gifs, stickers, or ads).
  ///
  /// - Parameters:
  ///   - item: A `MediaDomainModel` representing the media item whose dimensions and URL are to be fetched.
  /// - Returns: A tuple containing the width, height, and URL of the media item.
  ///
  /// This method helps in extracting essential information such as the aspect ratio of the media (for resizing) and
  /// the URL for displaying or prefetching content. The function supports multiple media types, such as clips, GIFs,
  /// stickers, and ads.
  private func getDimensions(from item: MediaDomainModel) -> (
    width: CGFloat, height: CGFloat, url: String
  ) {
    switch item.type {
    case .clips:
      guard let file = item.singleFile?.gif else {
        return (0, 0, "")
      }
      return (CGFloat(file.width), CGFloat(file.height), file.url)

    case .gifs, .stickers:
      guard let file = item.sm?.gif else {
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

  /// Calculates the optimal layout for a single row based on resizing, aspect ratio, and available width.
  /// It also handles special rules for ad positioning and scaling, ensuring that ads fit within the layout without
  /// disrupting the flow of other items.
  ///
  /// - Parameters:
  ///   - candidateItems: An array of `GridItemLayout` representing the items that are candidates for being placed in a row.
  ///   - itemMinWidth: The minimum width allowed for any media item in the row.
  ///   - adMaxResizePercent: The maximum percentage by which an ad's width can be resized to ensure it doesn't dominate the row.
  /// - Returns: A tuple containing the optimized row of items and the optimal row height.
  ///
  /// This method performs the core layout calculation for fitting media items in a row, considering their aspect ratio
  /// and available width. It also dynamically adjusts the row height and width, ensuring that the layout is balanced
  /// and aesthetically pleasing. Special rules for ads are also incorporated to ensure they do not disrupt the layout.
  private func calculateOptimalRow(
    _ candidateItems: [GridItemLayout], _ itemMinWidth: Int, _ adMaxResizePercent: Int
  ) -> ([GridItemLayout], CGFloat) {
    var minimumChange = CGFloat.greatestFiniteMagnitude
    var optimizedRow: [GridItemLayout] = []
    var optimalRowHeight: CGFloat = 0

    var currentMinHeight = minRowHeight
    var currentMaxHeight = maxRowHeight

    // Check if an ad exists in the row, and adjust height rules accordingly.
    let adIndex = candidateItems.firstIndex { $0.type == "ad" }
    if let adIndex = adIndex, adIndex > 1 {
      // If ad is after index 1 (i.e., 3rd+ position), reduce row to just 2 items
      /// If the ad is positioned after the first two items in the row, the number of items in the row is reduced to 2.
      /// This helps with better positioning of ads and ensures a clean, visually pleasing layout.
      let items = Array(candidateItems.prefix(2))
      return calculateOptimalRow(items, itemMinWidth, adMaxResizePercent)
    } else if let adIndex = adIndex {
      // If ad exists early, use its height as fixed for the row
      currentMinHeight = candidateItems[adIndex].height
      currentMaxHeight = candidateItems[adIndex].height
    }

    // Try every height from min to max and find best-fit row with least leftover width
    for height in Int(currentMinHeight)...Int(currentMaxHeight) {
      var itemsInRow: [GridItemLayout] = []

      for item in candidateItems {
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

        // Compute row total width including horizontal spacings
        let totalWidth =
          itemsInRow.reduce(0) { $0 + $1.newWidth } + CGFloat(itemsInRow.count - 1)
          * horizontalSpacing
        let change = containerWidth - totalWidth

        // Pick the row closest to exact fit (or if current row only had 1 item)
        if abs(change) < abs(minimumChange) || (optimizedRow.count == 1 && itemsInRow.count != 1) {
          if itemsInRow.count != 1 || optimizedRow.isEmpty {
            minimumChange = change
            optimizedRow = itemsInRow
            optimalRowHeight = CGFloat(height)
          }
        }
      }
    }

    // Final adjustment: spread leftover pixels across non-ad items to perfectly fill width
    /// In cases where the row does not fit perfectly due to an ad, we adjust the width of the non-ad items.
    /// This ensures the row fills the container width, making the layout look more uniform and balanced.
    /// The adjustment is done by calculating the leftover width and distributing it evenly across the non-ad items.
    let nonAdItems = optimizedRow.filter { $0.type != "ad" }
    let adjustmentPerItem = nonAdItems.isEmpty ? 0 : minimumChange / CGFloat(nonAdItems.count)

    for i in 0..<optimizedRow.count {
      if optimizedRow[i].type == "ad" {
        optimizedRow[i].width = optimizedRow[i].newWidth
      } else {
        optimizedRow[i].width = optimizedRow[i].newWidth + adjustmentPerItem
      }
      optimizedRow[i].height = optimalRowHeight
    }

    // MARK: - Ad Resize Logic (only if row contains ad)

    /// Ad Resize Logic: This block is responsible for handling the resizing of the ad in a row
    /// The goal is to ensure that ads are not overly stretched
    /// and that the overall row width is correctly balanced. If necessary, the ad width is reduced
    /// while redistributing the leftover space to other items.
    if let adIndex = adIndex, nonAdItems.count != optimizedRow.count {
      let itemsBelowMinWidth = nonAdItems.filter { $0.width < CGFloat(itemMinWidth) }

      if !itemsBelowMinWidth.isEmpty {
        // Force small items to min width
        for i in 0..<optimizedRow.count {
          if optimizedRow[i].type != "ad", optimizedRow[i].width < CGFloat(itemMinWidth) {
            optimizedRow[i].width = CGFloat(itemMinWidth)
          }
        }

        // Recalculate row width after forcing min width
        let newRowWidth =
          optimizedRow.reduce(0) { $0 + $1.width } + CGFloat(optimizedRow.count - 1)
          * horizontalSpacing

        if newRowWidth > containerWidth {
          var adItem = optimizedRow[adIndex]

          // Calculate how much we are allowed to shrink the ad
          let minAdWidth = adItem.width * (100 - CGFloat(adMaxResizePercent)) / 100
          var resizedAdWidth = adItem.width - (newRowWidth - containerWidth)

          if resizedAdWidth < minAdWidth {
            // Spread some of the excess to other items again if ad hit minimum size
            let adWidthDifference = minAdWidth - resizedAdWidth
            for i in 0..<optimizedRow.count {
              if optimizedRow[i].type != "ad", optimizedRow[i].width == CGFloat(itemMinWidth) {
                optimizedRow[i].width -= adWidthDifference / CGFloat(itemsBelowMinWidth.count)
              }
            }
            resizedAdWidth = minAdWidth
          }

          // Apply ad resize and update others to match new row height
          let scaleFactor = resizedAdWidth / adItem.width
          adItem.height *= scaleFactor
          adItem.width = resizedAdWidth
          adItem.newWidth = resizedAdWidth
          optimizedRow[adIndex] = adItem

          for i in 0..<optimizedRow.count {
            if optimizedRow[i].type != "ad" {
              optimizedRow[i].height = adItem.height
            }
          }
          optimalRowHeight = adItem.height
        }
      }
    }

    return (optimizedRow, optimalRowHeight)
  }

  // MARK: - Public: Generate full layout of multiple rows

  /// Divides the input items into rows, computes size and position for each media item.
  /// Handles ad placement, resizing, and spacing between items.
  ///
  /// - Parameters:
  ///   - items: The list of media items to be displayed.
  ///   - withMeta: Metadata used for layout, such as ad resize limits and item minimum width.
  /// - Returns: An array of `RowLayout` representing the layout of each row, with the correct position and size for each item.
  ///
  /// This method is the main public function of the `MasonryLayoutCalculator`. It generates a full layout by processing
  /// all the items into rows, determining the best arrangement and size for each item. The layout respects the
  /// item aspect ratios, horizontal spacing, and any special rules for ad items. Additionally, this function assigns
  /// appropriate x/y positions to each media item for rendering on screen.
  func createRows(from items: [MediaDomainModel], withMeta: GridMeta) -> [RowLayout] {
    var rows: [RowLayout] = []
    var nextItem = 0

    while nextItem < items.count {
      // Take maxItemsPerRow items to try building the next row
      let possibleItems = Array(items[nextItem..<min(nextItem + maxItemsPerRow, items.count)])

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
      let (rowItems, rowHeight) = calculateOptimalRow(
        possibleLayoutItems, withMeta.adMaxResizePercent, withMeta.itemMinWidth)
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
        currentX += rows[rowIndex].items[itemIndex].width + horizontalSpacing
      }
      currentY += rows[rowIndex].height + horizontalSpacing
    }

    return rows
  }
}
