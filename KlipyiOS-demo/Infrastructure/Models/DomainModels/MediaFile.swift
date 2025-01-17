struct MediaFile: Equatable {
    let mp4: MediaFileVariant?
    let gif: MediaFileVariant
    let webp: MediaFileVariant
}

struct MediaFileVariant: Equatable {
    let url: String
    let width: Int
    let height: Int
}

// Main domain model
struct MediaDomainModel: Identifiable, Equatable {
    let id: Int
    let title: String
    let slug: String
    let blurPreview: String
    let type: MediaType
    
    // File variants for different sizes
    let hd: MediaFile?
    let md: MediaFile?
    let sm: MediaFile?
    let xs: MediaFile?
    
    // For clips which have a single file variant
    let singleFile: MediaFile?
}