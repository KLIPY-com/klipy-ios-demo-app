
struct LazyGIFView: View {
  let item: GridItemLayout
  @State private var gifImage: GIFImage?
  
  var body: some View {
    Group {
      if let image = gifImage {
        image
          .aspectRatio(contentMode: .fill)
      } else {
        Color.gray.opacity(0.3)
          .onAppear {
            loadImage()
          }
      }
    }
  }
  
  private func loadImage() {
    Task {
      let image = GIFImage(source: .remoteURL(URL(string: item.url)!), frameRate: .dynamic)
      await MainActor.run {
        self.gifImage = image
      }
    }
  }
}
