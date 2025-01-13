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
