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
  
  let id: Int
  let url: String
  let title: String
  let slug: String
  let blurPreview: String
  let file: ClipFile
  let fileMeta: ClipFileMeta
  let type: MediaType
  
  enum CodingKeys: String, CodingKey {
    case url
    case title
    case slug
    case blurPreview = "blur_preview"
    case file
    case fileMeta = "file_meta"
    case type
  }
  
  // Custom init from decoder that sets the ID
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = Int.random(in: 1...Int.max)
    
    self.url = try container.decode(String.self, forKey: .url)
    self.title = try container.decode(String.self, forKey: .title)
    self.slug = try container.decode(String.self, forKey: .slug)
    self.blurPreview = try container.decode(String.self, forKey: .blurPreview)
    self.file = try container.decode(ClipFile.self, forKey: .file)
    self.fileMeta = try container.decode(ClipFileMeta.self, forKey: .fileMeta)
    self.type = try container.decode(MediaType.self, forKey: .type)
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
