//
//  GridItemLayout.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

//
//  GridItemLayout.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation

// MARK: - Layout Models

/// Represents a single media item in the grid layout.
/// Each instance of `GridItemLayout` corresponds to a media item (such as a GIF, video, or ad)
/// that will be displayed in a masonry-style grid layout. It holds the layout properties for each item,
/// including its size, position, and various media URLs for display and optimization.
///
/// - `id`: A unique identifier for the grid item. This is used to differentiate between items and is typically
///   assigned from a database or backend data model.
struct GridItemLayout: Identifiable {

  /// A unique identifier for this grid item.
  /// This ID is essential for distinguishing between media items in the layout, ensuring each item is
  /// uniquely identifiable for use in lists, grids, or when managing state.
  let id: Int64

  /// The URL to the media (e.g., GIF, clip, or ad).
  /// This is the primary URL used to display the media item. It could point to a low-quality or placeholder
  /// version of the media to optimize loading times and reduce data consumption.
  let url: String

  /// The high-quality URL for the media item.
  /// This URL is used to load a high-definition version of the media, often used when the item is displayed
  /// in full view or when high quality is required (e.g., for a detailed preview or an ad).
  let highQualityUrl: String

  /// A reference to the media file, typically used for MP4 media.
  /// If the media is a video or a file with MP4 format, this object holds the related data for the video file.
  /// This is optional, as not all media items will have an associated MP4 file.
  let mp4Media: MediaFile?

  /// The URL for a preview image of the media item.
  /// This preview image is usually a lower resolution or a thumbnail image used for faster loading when displaying
  /// a list or grid of items. It serves as a placeholder or quick preview of the media.
  let previewUrl: String

  /// The current width of the item.
  /// This represents the width of the media item as it will be rendered in the grid. The width is calculated
  /// based on the aspect ratio of the media item and the available space in the grid layout.
  var width: CGFloat

  /// The current height of the item.
  /// This represents the height of the media item, adjusted according to its aspect ratio or any constraints
  /// from the layout algorithm (e.g., maximum row height).
  var height: CGFloat

  /// The x-position of the item in the grid.
  /// This value is calculated dynamically during the layout process, indicating the horizontal position of the item
  /// relative to other items in the same row. It is used to position the item correctly in the grid when rendering.
  var xPosition: CGFloat = 0

  /// The y-position of the item in the grid.
  /// Similar to `xPosition`, this value represents the vertical position of the item relative to other items in
  /// the same column or row. It ensures proper placement of the item in the grid layout.
  var yPosition: CGFloat = 0

  /// The original width of the media item.
  /// This is the width of the media item before any layout adjustments are made. The original width is used to
  /// calculate resizing and to maintain the correct aspect ratio for the item as it is resized.
  let originalWidth: CGFloat

  /// The original height of the media item.
  /// Like `originalWidth`, this is the unmodified height of the media item. It is used for maintaining the aspect
  /// ratio of the media item during layout calculations.
  let originalHeight: CGFloat

  /// The new width of the item after applying layout and resizing rules.
  /// This is used to store the new width after the item has been resized to fit within the grid. For example,
  /// when the media item’s aspect ratio is maintained, the new width is calculated based on the current height.
  var newWidth: CGFloat = 0

  /// The type of media represented by this grid item.
  /// This string value indicates the media type, such as a GIF, clip, sticker, or ad. It helps the layout
  /// algorithm to determine how to treat and display the item. Ads, for example, might need different handling
  /// than GIFs or clips.
  let type: String

  /// The title of the media item.
  /// This is the textual title of the media item, often used for display purposes (e.g., captions or descriptions).
  let title: String

  /// A slug associated with the media item.
  /// This is a unique, URL-friendly identifier for the item, often used for routing or in URLs to represent the
  /// item in a web-friendly format (e.g., "my-gif-item" or "clip-123").
  let slug: String
}
