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
  
  let id: Int?
  let title: String?
  let slug: String?
  let blurPreview: String?
  let file: SizeVariants?
  let type: MediaType
  let width: Int?
  let height: Int?
  let content: String?
}

struct StickerFileBased {
  let id: Int?
  let title: String?
  let slug: String?
  let blurPreview: String?
  let file: SizeVariants?
  let type: MediaType
  
  init(from container: KeyedDecodingContainer<StickerItem.CodingKeys>) throws {
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    slug = try container.decodeIfPresent(String.self, forKey: .slug)
    blurPreview = try container.decodeIfPresent(String.self, forKey: .blurPreview)
    file = try container.decodeIfPresent(SizeVariants.self, forKey: .file)
    type = try container.decode(MediaType.self, forKey: .type)
  }
}

extension StickerItem {
  enum CodingKeys: String, CodingKey {
    case id, title, slug
    case blurPreview = "blur_preview"
    case file, type, width, height, content
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let content = try container.decodeIfPresent(String.self, forKey: .content) {
      let type = try container.decode(MediaType.self, forKey: .type)
      let width = try container.decodeIfPresent(Int.self, forKey: .width)
      let height = try container.decodeIfPresent(Int.self, forKey: .height)
      self.init(contentBased: content, width: width, height: height, type: type)
      return
    }
    
    let fileBased = try StickerFileBased(from: container)
    self.init(fileBased: fileBased)
  }
  
  private init(contentBased content: String, width: Int?, height: Int?, type: MediaType) {
    self.content = content
    self.width = width
    self.height = height
    self.type = type
    self.id = nil
    self.title = nil
    self.slug = nil
    self.blurPreview = nil
    self.file = nil
  }
  
  private init(fileBased item: StickerFileBased) {
    self.id = item.id
    self.title = item.title
    self.slug = item.slug
    self.blurPreview = item.blurPreview
    self.file = item.file
    self.type = item.type
    self.width = nil
    self.height = nil
    self.content = nil
  }
}

extension StickerItem {
  func toDomain() -> MediaDomainModel {
    if let content = content {
      return try! makeContentBasedModel(content: content)
    }

    return try! makeFileBasedModel()
  }
  
  private func makeContentBasedModel(content: String) throws -> MediaDomainModel {
    guard let width = width, let height = height else {
      throw fatalError()
    }
    
    return MediaDomainModel(
      id: 0,
      title: "",
      slug: "",
      blurPreview: "",
      type: type,
      addContentProperties: .init(width: width, height: height, content: content),
      hd: .empty,
      md: .empty,
      sm: .empty,
      xs: .empty,
      singleFile: nil
    )
  }
  
  private func makeFileBasedModel() throws -> MediaDomainModel {
    guard let id = id,
          let title = title,
          let slug = slug,
          let file = file else {
      throw fatalError()
    }
    
    return MediaDomainModel(
      id: id,
      title: title,
      slug: slug,
      blurPreview: blurPreview,
      type: type,
      addContentProperties: nil,
      hd: file.hd.toDomain(),
      md: file.md.toDomain(),
      sm: file.sm.toDomain(),
      xs: file.xs.toDomain(),
      singleFile: nil
    )
  }
}


