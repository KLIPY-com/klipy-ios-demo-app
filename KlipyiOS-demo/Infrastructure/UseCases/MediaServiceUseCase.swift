//
//  MediaServiceUseCase.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import Foundation

protocol MediaServiceUseCase {
  associatedtype Item: Codable

  func fetchTrendingItems(page: Int, perPage: Int) async throws -> AnyResponse<Item>
  func searchItems(query: String, page: Int, perPage: Int) async throws -> AnyResponse<Item>
}
