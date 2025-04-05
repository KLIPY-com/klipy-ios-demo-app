//
//  PaginatedData.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct PaginatedDomain {
  let items: [MediaDomainModel]
  let currentPage: Int
  let perPage: Int
  let hasNext: Bool
  let gridMeta: GridMeta
}

struct PaginatedData<T: Codable>: Codable {
  let data: [T]
  let currentPage: Int
  let perPage: Int
  let hasNext: Bool
  let gridMeta: GridMeta
  
  enum CodingKeys: String, CodingKey {
    case data
    case currentPage = "current_page"
    case perPage = "per_page"
    case hasNext = "has_next"
    case gridMeta = "meta"
  }
}

struct GridMeta: Codable {
  var itemMinWidth: Int
  var adMaxResizePercent: Int
  
  enum CodingKeys: String, CodingKey {
    case itemMinWidth = "item_min_width"
    case adMaxResizePercent = "ad_max_resize_percent"
  }
}
