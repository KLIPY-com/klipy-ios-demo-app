//
//  PaginatedData.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

import Foundation

struct PaginatedData<T: Codable>: Codable {
  let data: [T]
  let currentPage: Int
  let perPage: Int
  let hasNext: Bool
  
  enum CodingKeys: String, CodingKey {
    case data
    case currentPage = "current_page"
    case perPage = "per_page"
    case hasNext = "has_next"
  }
}
