class PreviewViewModel: ObservableObject {
    @Published var selectedItem: (item: GridItemLayout, frame: CGRect)? = nil
    @Published var isDragging = false
    @Published var dragOffset: CGSize = .zero
    @Published var dragScale: CGFloat = 1.0
}

// Telegram-style preview overlay
struct TelegramPreviewOverlay: View {
    @ObservedObject var viewModel: PreviewViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background overlay
                Color.black
                    .opacity(viewModel.isDragging ? 0.5 * (1 - abs(viewModel.dragOffset.height / 400)) : 0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onDismiss()
                    }
                
                if let selectedItem = viewModel.selectedItem {
                    let startBounds = selectedItem.frame
                    let screenSize = geometry.size
                    
                    // Calculate final frame
                    let targetSize = calculateTargetSize(
                        originalSize: CGSize(
                            width: selectedItem.item.width,
                            height: selectedItem.item.height
                        ),
                        screenSize: screenSize
                    )
                    
                    let targetFrame = CGRect(
                        x: (screenSize.width - targetSize.width) / 2,
                        y: (screenSize.height - targetSize.height) / 2,
                        width: targetSize.width,
                        height: targetSize.height
                    )
                    
                    // Animated preview
                    AnimatedImage(url: URL(string: selectedItem.item.url))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: targetSize.width, height: targetSize.height)
                        .offset(
                            x: viewModel.isDragging ? viewModel.dragOffset.width : 0,
                            y: viewModel.isDragging ? viewModel.dragOffset.height : 0
                        )
                        .scaleEffect(viewModel.dragScale)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.isDragging = true
                                    viewModel.dragOffset = value.translation
                                    
                                    // Calculate scale based on drag distance
                                    let dragDistance = abs(value.translation.height)
                                    viewModel.dragScale = max(0.7, min(1, 1 - (dragDistance / 1000)))
                                }
                                .onEnded { value in
                                    let dragDistance = abs(value.translation.height)
                                    if dragDistance > 100 {
                                        onDismiss()
                                    } else {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            viewModel.isDragging = false
                                            viewModel.dragOffset = .zero
                                            viewModel.dragScale = 1
                                        }
                                    }
                                }
                        )
                }
            }
        }
    }
    
    private func calculateTargetSize(originalSize: CGSize, screenSize: CGSize) -> CGSize {
        let maxWidth = screenSize.width * 0.9
        let maxHeight = screenSize.height * 0.7
        
        let widthRatio = maxWidth / originalSize.width
        let heightRatio = maxHeight / originalSize.height
        
        let scale = min(widthRatio, heightRatio)
        
        return CGSize(
            width: originalSize.width * scale,
            height: originalSize.height * scale
        )
    }
}