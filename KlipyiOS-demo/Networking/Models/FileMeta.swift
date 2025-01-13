struct FileMeta: Codable {
    let width: Int
    let height: Int
}

struct FileFormats: Codable {
    let mp4: String
    let gif: String
    let webp: String
}

struct FileMetaFormats: Codable {
    let mp4: FileMeta
    let gif: FileMeta
    let webp: FileMeta
    
    enum CodingKeys: String, CodingKey {
        case mp4
        case gif
        case webp
    }
}