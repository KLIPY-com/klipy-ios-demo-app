//
//  File.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//


import Foundation

public extension JSONDecoder {
  static var custom: JSONDecoder {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }
}
