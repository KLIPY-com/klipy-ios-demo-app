public enum MediaType {
    case clips
    case gifs
    case stickers
    
    var path: String {
        switch self {
        case .clips: return "clips"
        case .gifs: return "gifs"
        case .stickers: return "stickers"
        }
    }
}