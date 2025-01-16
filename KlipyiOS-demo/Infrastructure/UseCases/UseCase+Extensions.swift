//
//  UseCase+Extensions.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import Foundation
import Moya

extension GifServiceUseCase: MediaServiceUseCase {
  typealias Item = GifItem
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<GifItem> {
    try await searchGifs(query: query, page: page, perPage: perPage)
  }
  
  func fetchTrendingItems(page: Int, perPage: Int) async throws -> AnyResponse<GifItem> {
    try await fetchTrending(page: page, perPage: perPage)
  }
}

extension StickersServiceUseCase: MediaServiceUseCase {
  typealias Item = StickerItem
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<StickerItem> {
    try await searchStickers(query: query, page: page, perPage: perPage)
  }
  
  func fetchTrendingItems(page: Int, perPage: Int) async throws -> AnyResponse<StickerItem> {
    try await fetchTrending(page: page)
  }
}

extension ClipsServiceUseCase: MediaServiceUseCase {
  typealias Item = ClipItem
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<ClipItem> {
    try await searchClips(query: query, page: page, perPage: perPage)
  }
  
  func fetchTrendingItems(page: Int, perPage: Int) async throws -> AnyResponse<ClipItem> {
    try await fetchTrending(page: page)
  }
}
