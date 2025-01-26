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
}

struct MediaFileVariant: Equatable {
  let url: String
  let width: Int
  let height: Int
}

struct MediaDomainModel: Identifiable, Equatable {
  let id: Int
  let title: String
  let slug: String
  let blurPreview: String?
  let type: MediaType
  
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
    
    return xs ?? sm ?? md ?? hd!
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
