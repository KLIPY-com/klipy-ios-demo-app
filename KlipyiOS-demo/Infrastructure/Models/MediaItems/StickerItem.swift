//
//  StickerItem.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct StickerItem: MediaItem {
  static func == (lhs: StickerItem, rhs: StickerItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  let id: Int
  let title: String
  let slug: String
  let blurPreview: String?
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

extension StickerItem {
  func toDomain() -> MediaDomainModel {
    MediaDomainModel(
      id: id,
      title: title,
      slug: slug,
      blurPreview: blurPreview,
      type: type,
      hd: file.hd.toDomain(),
      md: file.md.toDomain(),
      sm: file.sm.toDomain(),
      xs: file.xs.toDomain(),
      singleFile: nil
    )
  }
}
