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
  case none
  
  func fetchTrending(page: Int, perPage: Int) async throws -> PaginatedDomain {
    switch self {
    case .gif(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .clip(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .sticker(let service):
      let response = try await service.fetchTrending(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .none:
      return PaginatedDomain(items: [], currentPage: page, perPage: perPage, hasNext: false)
    }
  }
  
  func fetchRecents(page: Int, perPage: Int) async throws -> PaginatedDomain {
    switch self {
    case .gif(let service):
      let response = try await service.fetchRecentItems(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .clip(let service):
      let response = try await service.fetchRecentItems(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .sticker(let service):
      let response = try await service.fetchRecentItems(page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .none:
      return PaginatedDomain(items: [], currentPage: page, perPage: perPage, hasNext: false)
    }
  }
  
  func search(query: String, page: Int, perPage: Int) async throws -> PaginatedDomain {
    switch self {
    case .gif(let service):
      let response = try await service.searchGifs(query: query, page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .clip(let service):
      let response = try await service.searchClips(query: query, page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .sticker(let service):
      let response = try await service.searchStickers(query: query, page: page, perPage: perPage)
      return PaginatedDomain(
        items: response.data.data.map { $0.toDomain() },
        currentPage: response.data.currentPage,
        perPage: response.data.perPage,
        hasNext: response.data.hasNext
      )
    case .none:
      return PaginatedDomain(items: [], currentPage: page, perPage: perPage, hasNext: false)
    }
  }
  
  func categories() async throws -> Categories {
    switch self {
    case .gif(let service):
      return try await service.fetchCategories()
    case .clip(let service):
      return try await service.fetchCategories()
    case .sticker(let service):
      return try await service.fetchCategories()
    case .none:
      return .init(result: false, data: [])
    }
  }
  
  func trackView(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.trackView(slug: slug)
    case .clip(let service): return try await service.trackView(slug: slug)
    case .sticker(let service): return try await service.trackView(slug: slug)
    case .none: return .init(result: true)
    }
  }
  
  func trackShare(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.trackShare(slug: slug)
    case .clip(let service): return try await service.trackShare(slug: slug)
    case .sticker(let service): return try await service.trackShare(slug: slug)
    case .none: return .init(result: true)
    }
  }
  
  func hideFromRecent(slug: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.hideFromRecent(slug: slug)
    case .clip(let service): return try await service.hideFromRecent(slug: slug)
    case .sticker(let service): return try await service.hideFromRecent(slug: slug)
    case .none: return .init(result: true)
    }
  }
  
  func report(slug: String, reason: String) async throws -> FireAndForgetResponse {
    switch self {
    case .gif(let service): return try await service.reportGif(slug: slug, reason: reason)
    case .clip(let service): return try await service.reportClip(slug: slug, reason: reason)
    case .sticker(let service): return try await service.reportSticker(slug: slug, reason: reason)
    case .none: return .init(result: true)
    }
  }
  
  static func create(for type: MediaType) -> MediaService {
    switch type {
    case .gifs: return .gif(GifServiceUseCase())
    case .clips: return .clip(ClipsServiceUseCase())
    case .stickers: return .sticker(StickersServiceUseCase())
    case .ad: return .none
    }
  }
}

