//
//  MediaService.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import Foundation

enum MediaService {
  case gif(GifServiceUseCase)
  case clip(ClipsServiceUseCase)
  case sticker(StickersServiceUseCase)
  
  func fetchTrending(page: Int, perPage: Int) async throws -> [MediaDomainModel] {
    switch self {
    case .gif(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      return response.data.data.map { $0.toDomain() }
    case .clip(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      let domainClips = response.data.data.map { $0.toDomain() }
      return domainClips
    case .sticker(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      return response.data.data.map { $0.toDomain() }
    }
  }
  
  func search(query: String, page: Int, perPage: Int) async throws -> [MediaDomainModel] {
    switch self {
    case .gif(let service):
      let response = try await service.searchGifs(query: query, page: page, perPage: perPage)
      return response.data.data.map { $0.toDomain() }
    case .clip(let service):
      let response = try await service.searchClips(query: query, page: page, perPage: perPage)
      return response.data.data.map { $0.toDomain() }
    case .sticker(let service):
      let response = try await service.searchStickers(query: query, page: page, perPage: perPage)
      return response.data.data.map { $0.toDomain() }
    }
  }
  
  func trackView(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.trackView(slug: slug)
    case .clip(let service): return try await service.trackView(slug: slug)
    case .sticker(let service): return try await service.trackView(slug: slug)
    }
  }
  
  func trackShare(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.trackShare(slug: slug)
    case .clip(let service): return try await service.trackShare(slug: slug)
    case .sticker(let service): return try await service.trackShare(slug: slug)
    }
  }
  
  func hideFromRecent(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.hideFromRecent(slug: slug)
    case .clip(let service): return try await service.hideFromRecent(slug: slug)
    case .sticker(let service): return try await service.hideFromRecent(slug: slug)
    }
  }
  
  func report(slug: String, reason: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.reportGif(slug: slug, reason: reason)
    case .clip(let service): return try await service.reportClip(slug: slug, reason: reason)
    case .sticker(let service): return try await service.reportSticker(slug: slug, reason: reason)
    }
  }
  
  static func create(for type: MediaType) -> MediaService {
    switch type {
    case .gifs: return .gif(GifServiceUseCase())
    case .clips: return .clip(ClipsServiceUseCase())
    case .stickers: return .sticker(StickersServiceUseCase())
    }
  }
}
