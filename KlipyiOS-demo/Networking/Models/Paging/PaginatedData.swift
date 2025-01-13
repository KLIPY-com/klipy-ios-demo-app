struct PaginatedData: Codable {
    let data: [ClipItem]
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