//
//  RowLayout.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation

/// Represents a row of media items in the grid layout.
/// A `RowLayout` contains an array of `GridItemLayout` objects that represent individual media items (e.g., GIFs, videos, or ads),
/// along with the height of the row. This structure is used to group the items in a row for the purpose of rendering them in a
/// masonry-style grid layout. It helps in calculating and positioning the items within the grid.
struct RowLayout {

  /// The items within this row.
  /// This array holds all the individual `GridItemLayout` objects that belong to the current row. Each `GridItemLayout`
  /// contains the layout information for a single media item, including its size, position, and media URLs.
  ///
  /// - Example: A row might contain 4 GIFs, each represented by a `GridItemLayout` object in this array.
  var items: [GridItemLayout]

  /// The height of this row.
  /// The `height` value represents the total height of the row, calculated based on the layout rules and the media items'
  /// aspect ratios. This ensures that each row in the grid maintains a consistent height, even when the sizes of the items
  /// within it may vary.
  ///
  /// - Example: If the row contains media items of varying sizes, the height will be adjusted to accommodate the largest
  /// item’s height (based on the layout algorithm’s rules, such as respecting minimum and maximum row height constraints).
  var height: CGFloat
}
