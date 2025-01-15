final class GIFLoader {
    static let shared = GIFLoader()
    private let cache = ImageCache.shared
    
    func loadGIF(from url: String) async -> GIFImage? {
        // Check cache first
        if let cachedImage = cache.getImage(forKey: url) {
            return cachedImage
        }
        
        // Load new image
        do {
            let image = await GIFImage(source: .remoteURL(URL(string: url)!), frameRate: .dynamic)
            cache.setImage(image, forKey: url)
            return image
        } catch {
            print("Error loading GIF: \(error)")
            return nil
        }
    }
}