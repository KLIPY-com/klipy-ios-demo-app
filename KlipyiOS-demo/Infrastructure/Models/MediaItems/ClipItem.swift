//
//  ClipItem.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct ClipItem: MediaItem {
  static func == (lhs: ClipItem, rhs: ClipItem) -> Bool {
    return lhs.id == rhs.id
  }
  
  let id: Int?
  let url: String?
  let title: String?
  let slug: String?
  let blurPreview: String?
  let file: ClipFile?
  let fileMeta: ClipFileMeta?
  let type: MediaType
  let width: Int?
  let height: Int?
  let content: String?
  
  enum CodingKeys: String, CodingKey {
    case url
    case title
    case slug
    case blurPreview = "blur_preview"
    case file
    case fileMeta = "file_meta"
    case type
    case height
    case width
    case content
  }
}

struct ClipyFileBased {
  let id: Int
  let url: String
  let title: String
  let slug: String
  let blurPreview: String?
  let file: ClipFile
  let fileMeta: ClipFileMeta
  let type: MediaType
  
  init(from container: KeyedDecodingContainer<ClipItem.CodingKeys>) throws {
    id = Int.random(in: 1...Int.max)
    url = try container.decode(String.self, forKey: .url)
    title = try container.decode(String.self, forKey: .title)
    slug = try container.decode(String.self, forKey: .slug)
    blurPreview = try container.decodeIfPresent(String.self, forKey: .blurPreview)
    file = try container.decode(ClipFile.self, forKey: .file)
    fileMeta = try container.decode(ClipFileMeta.self, forKey: .fileMeta)
    type = try container.decode(MediaType.self, forKey: .type)
  }
}

extension ClipItem {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let content = try container.decodeIfPresent(String.self, forKey: .content) {
      let type = try container.decode(MediaType.self, forKey: .type)
      let width = try container.decodeIfPresent(Int.self, forKey: .width)
      let height = try container.decodeIfPresent(Int.self, forKey: .height)
      self.init(contentBased: content, width: width, height: height, type: type)
      return
    }

    let fileBased = try ClipyFileBased(from: container)
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
    self.fileMeta = nil
    self.file = nil
    self.url = nil
  }
  
  private init(fileBased item: ClipyFileBased) {
    self.id = item.id
    self.url = item.url
    self.title = item.title
    self.slug = item.slug
    self.blurPreview = item.blurPreview
    self.file = item.file
    self.fileMeta = item.fileMeta
    self.type = item.type
    self.width = nil
    self.height = nil
    self.content = nil
  }
}

struct ClipFile: Codable {
  var mp4: String
  var gif: String
  var webp: String
}

struct ClipFileMeta: Codable {
  var mp4: ClipMeta
  var gif: ClipMeta
  var webp: ClipMeta
}

struct ClipMeta: Codable {
  var width: Int
  var height: Int
}

extension ClipItem {
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
      hd: nil,
      md: nil,
      sm: nil,
      xs: nil,
      singleFile: MediaFile(
        mp4: MediaFileVariant(
          url: file.mp4,
          width: fileMeta!.mp4.width,
          height: fileMeta!.mp4.height
        ),
        gif: MediaFileVariant(
          url: file.gif,
          width: fileMeta!.gif.width,
          height: fileMeta!.gif.height
        ),
        webp: MediaFileVariant(
          url: file.webp,
          width: fileMeta!.webp.width,
          height: fileMeta!.webp.height
        )
      )
    )
  }
}
