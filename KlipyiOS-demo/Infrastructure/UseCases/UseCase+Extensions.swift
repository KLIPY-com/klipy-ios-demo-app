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
  
  func fetchTrending(page: Int, perPage: Int) async throws -> <<error type>> {
    try await t
  }
}

extension StickersServiceUseCase: MediaServiceUseCase {
  typealias Item = StickerItem
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<StickerItem> {
    try await searchStickers(query: query, page: page, perPage: perPage)
  }
}

extension ClipsServiceUseCase: MediaServiceUseCase {
  typealias Item = ClipItem
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<ClipItem> {
    try await searchClips(query: query, page: page, perPage: perPage)
  }
}
