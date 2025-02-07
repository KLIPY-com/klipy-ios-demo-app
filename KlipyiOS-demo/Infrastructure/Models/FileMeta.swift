//
//  FileMeta.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 13.01.25.
//

struct FileMeta: Codable {
  let url: String
  let width: Int
  let height: Int
  let size: Int
}

struct FileFormats: Codable {
  let mp4: FileMeta?
  let gif: FileMeta
  let webp: FileMeta
}

struct SizeVariants: Codable {
  let hd: FileFormats
  let md: FileFormats
  let sm: FileFormats
  let xs: FileFormats
}

extension FileFormats {
  func toDomain() -> MediaFile {
    MediaFile(
      mp4: mp4.map { meta in
        MediaFileVariant(
          url: meta.url,
          width: meta.width,
          height: meta.height
        )
      },
      gif: MediaFileVariant(
        url: gif.url,
        width: gif.width,
        height: gif.height
      ),
      webp: MediaFileVariant(
        url: webp.url,
        width: webp.width,
        height: webp.height
      )
    )
  }
}
