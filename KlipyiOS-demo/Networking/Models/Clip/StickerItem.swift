//
//  ClipItem.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct ClipItem: Codable {
  let url: String
  let title: String
  let slug: String
  let blurPreview: String
  let file: FileFormats
  let fileMeta: FileMeta
  let type: String
  
  enum CodingKeys: String, CodingKey {
    case url
    case title
    case slug
    case blurPreview = "blur_preview"
    case file
    case fileMeta = "file_meta"
    case type
  }
}
