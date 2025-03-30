//
//  MediaFile.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

struct MediaFile: Equatable {
  let mp4: MediaFileVariant?
  let gif: MediaFileVariant
  let webp: MediaFileVariant
  
  static let empty = MediaFile(
    mp4: nil,
    gif: MediaFileVariant(
      url: "",
      width: 0,
      height: 0
    ),
    webp: MediaFileVariant(
      url: "",
      width: 0,
      height: 0
    )
  )
}

struct MediaFileVariant: Equatable {
  let url: String
  let width: Int
  let height: Int
}

struct AddContentProperties {
  let width: Int
  let height: Int
  let content: String
}

struct MediaDomainModel: Identifiable, Equatable {
  static func == (lhs: MediaDomainModel, rhs: MediaDomainModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  let id: Int
  let title: String
  let slug: String
  let blurPreview: String?
  let type: MediaType
  let addContentProperties: AddContentProperties?
  
  let hd: MediaFile?
  let md: MediaFile?
  let sm: MediaFile?
  let xs: MediaFile?
  
  let singleFile: MediaFile?
}

extension MediaDomainModel {
  var bestAvailableFile: MediaFile {
    if let single = singleFile {
      return single
    }
    
    return hd ?? md ?? sm ?? xs!
  }
  
  var previewFile: MediaFile {
    if let single = singleFile {
      return single
    }
    
    return sm ?? md ?? hd!
  }
  
  func getFileVariant(size: MediaSize) -> MediaFile? {
    if let single = singleFile {
      return single
    }
    
    switch size {
    case .hd: return hd
    case .md: return md
    case .sm: return sm
    case .xs: return xs
    }
  }
}

enum MediaSize {
  case hd
  case md
  case sm
  case xs
}
