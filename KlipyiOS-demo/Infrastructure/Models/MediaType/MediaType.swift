//
//  MediaType.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//


import Foundation

public enum MediaType: String, Codable {
  case clips = "clip"
  case gifs = "gif"
  case stickers = "sticker"
  
  var path: String {
    switch self {
    case .clips: return "clips"
    case .gifs: return "gifs"
    case .stickers: return "stickers"
    }
  }
}

extension MediaType {
  var displayName: String {
    switch self {
    case .clips: return "CLIPs"
    case .gifs: return "GIFs"
    case .stickers: return "STICKERs"
    }
  }
  
  static func from(string: String) -> MediaType? {
    return MediaType(rawValue: string.lowercased())
  }
}
