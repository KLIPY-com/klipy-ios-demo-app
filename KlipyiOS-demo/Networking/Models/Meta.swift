// MARK: - Base Models
struct Meta: Codable {
    // Add any specific meta properties here if needed
    
    enum CodingKeys: String, CodingKey {
        // Define coding keys for meta properties
    }
}

struct MediaSection: Codable {
    let isAlive: Bool
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case isAlive = "is_alive"
        case meta
    }
}

// MARK: - Root Model
struct MediaContent: Codable {
    let clips: MediaSection
    let gifs: MediaSection
    let stickers: MediaSection
    
    enum CodingKeys: String, CodingKey {
        case clips
        case gifs
        case stickers
    }
}

// MARK: - Example Usage
extension MediaContent {
    static func decode(from jsonString: String) throws -> MediaContent {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NSError(domain: "MediaContent", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON string"])
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(MediaContent.self, from: jsonData)
    }
    
    func encode() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(self)
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "MediaContent", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode to JSON string"])
        }
        
        return jsonString
    }
}

// MARK: - Example Creation
extension MediaContent {
    static var example: MediaContent {
        MediaContent(
            clips: MediaSection(isAlive: true, meta: Meta()),
            gifs: MediaSection(isAlive: true, meta: Meta()),
            stickers: MediaSection(isAlive: true, meta: Meta())
        )
    }
}