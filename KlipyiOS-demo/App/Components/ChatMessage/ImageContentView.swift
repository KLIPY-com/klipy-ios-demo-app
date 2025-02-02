// MARK: - Image Content View
private struct ImageContentView: View {
    let mediaItem: GridItemLayout
    
    var body: some View {
        AnimatedImage(url: URL(string: mediaItem.url), isAnimating: .constant(true)) {
            WebImage(url: URL(string: mediaItem.previewUrl))
                .resizable()
                .transition(.fade)
                .aspectRatio(contentMode: .fill)
        }
        .resizable()
        .frame(width: mediaItem.width, height: mediaItem.height)
        .aspectRatio(contentMode: .fill)
        .cornerRadius(ChatMessageConfiguration.Layout.cornerRadius)
    }
}
