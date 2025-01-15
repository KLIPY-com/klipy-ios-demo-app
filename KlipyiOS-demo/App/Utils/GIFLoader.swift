//
//  GIFLoader.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import GIFImage
import Foundation
import WebKit

final class GIFLoader {
  static let shared = GIFLoader()
  
  func loadGIF(from url: String) async -> GIFImage? {
    do {
      let image = await GIFImage(source: .remoteURL(URL(string: url)!), frameRate: .dynamic)
      return image
    } catch {
      print("Error loading GIF: \(error)")
      return nil
    }
  }
}
