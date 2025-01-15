//
//  GifItem.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct GifItem: Codable, Equatable {
  static func == (lhs: GifItem, rhs: GifItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  let id: Int
  let title: String
  let slug: String
  let blurPreview: String
  let file: SizeVariants
  let type: MediaType
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case slug
    case blurPreview = "blur_preview"
    case file
    case type
  }
}
