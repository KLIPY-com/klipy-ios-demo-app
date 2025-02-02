import Foundation

struct MediaCategory: Identifiable, Equatable {
    enum ContentType {
        case trending
        case recents
        case none
    }
    
    let id = UUID()
    let name: String
    let iconUrl: String
    let type: ContentType
    
    init(name: String, type: ContentType = .none) {
        self.name = name
        self.iconUrl = "\(CATEGORY_FATCH_URL)\(name).png"
        self.type = type
    }
}