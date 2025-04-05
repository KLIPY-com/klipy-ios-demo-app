//
//  GridItemLayout.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation

// MARK: - Layout Models
struct GridItemLayout: Identifiable {
  let id: Int64
  let url: String
  let highQualityUrl: String
  let mp4Media: MediaFile?
  let previewUrl: String
  var width: CGFloat
  var height: CGFloat
  var xPosition: CGFloat = 0
  var yPosition: CGFloat = 0
  let originalWidth: CGFloat
  let originalHeight: CGFloat
  var newWidth: CGFloat = 0
  let type: String
  let title: String
  let slug: String
}
