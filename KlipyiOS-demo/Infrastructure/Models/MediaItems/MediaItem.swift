//
//  MediaItem.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import Foundation

protocol MediaItem: Codable, Equatable, Identifiable {
  var id: Int? { get }
  var title: String? { get }
  var slug: String? { get }
  var blurPreview: String? { get }
  var type: MediaType { get }
}
