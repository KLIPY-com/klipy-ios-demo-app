import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MenuContainerModifier: ViewModifier {
  @Binding var isPresented: Bool
  let onAction: (MenuAction) -> Void
  
  func body(content: Content) -> some View {
    VStack(spacing: 16) {
      content
      
      if isPresented {
        CustomMenu(onAction: onAction, isPresented: $isPresented)
          .frame(width: 160)
          .scaleEffect(0.8)
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
  }
}

extension View {
  func menuOverlay(
    isPresented: Binding<Bool>,
    onAction: @escaping (MenuAction) -> Void
  ) -> some View {
    self.modifier(MenuContainerModifier(isPresented: isPresented, onAction: onAction))
  }
}

struct TelegramPreviewOverlay: View {
  @ObservedObject var viewModel: PreviewViewModel

  @State private var showingMenu = false
  @State private var isMp4Playing: Bool = false
  @State private var videoPlayer: LoopingVideoPlayer?

  let onSend: (GridItemLayout) -> Void
  let onReport: (String, ReportReason) -> Void
  
  let onDismiss: () -> Void
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VisualEffectView(effect: UIBlurEffect(style: .dark))
          .opacity({
            if viewModel.isDragging {
              let dragPercentage = abs(viewModel.dragOffset.height) / 300
              return 0.8 * (1.0 - dragPercentage)
            }
            return 0.8
          }())
          .ignoresSafeArea()
          .onTapGesture {
            onDismiss()
          }
        
        if let selectedItem = viewModel.selectedItem {
          let screenSize = geometry.size
          let targetSize = calculateTargetSize(
            originalSize: CGSize(
              width: selectedItem.item.width,
              height: selectedItem.item.height
            ),
            screenSize: screenSize,
            isMenuShown: showingMenu
          )
          
          VStack {
            Spacer()
            
            Group {
              if let mp4Url = selectedItem.item.mp4Media?.mp4?.url {
                LoopingVideoPlayer(videoID: selectedItem.item.url, url: URL(string: mp4Url)!, isPlaying: $isMp4Playing)
                  .aspectRatio(contentMode: .fill)
                  .frame(width: targetSize.width, height: targetSize.height)
                  .onDisappear {
                    isMp4Playing = false
                  }
              } else {
                AnimatedImage(url: URL(string: selectedItem.item.url))
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: targetSize.width, height: targetSize.height)
              }
            }
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
              .onAppear {
                showingMenu = true
              }
              .clipShape(.rect(cornerRadius: 12, style: .continuous))
              .menuOverlay(isPresented: $showingMenu, onAction: handleMenuAction)
            
            Spacer()
          }
        }
      }
    }
  }
  
  private func handleMenuAction(_ action: MenuAction) {
    guard let selectedItem = viewModel.selectedItem else { return }
    
    withAnimation(.spring(response: 0.3)) {
      showingMenu = false
      onDismiss()
    }
    
    switch action {
    case .send:
      onSend(selectedItem.item)
    case .report(let reason):
      onReport(selectedItem.item.url, reason)
    }
  }
  
  private func calculateScale() -> CGFloat {
    if viewModel.isDragging {
      return viewModel.dragScale
    }
    return showingMenu ? 0.85 : 1.0
  }
  
  private func calculateTargetSize(
    originalSize: CGSize,
    screenSize: CGSize,
    isMenuShown: Bool
  ) -> CGSize {
    let maxWidth = screenSize.width * 0.9 * (isMenuShown ? 0.8 : 0.9)
    let maxHeight = screenSize.height * (isMenuShown ? 0.6 : 0.7)
    
    let widthRatio = maxWidth / originalSize.width
    let heightRatio = maxHeight / originalSize.height
    
    let scale = min(widthRatio, heightRatio)
    
    return CGSize(
      width: originalSize.width * scale,
      height: originalSize.height * scale
    )
  }
  
  private func playHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
    impactFeedback.prepare()
    impactFeedback.impactOccurred()
  }
}

struct TelegramPreviewOverlay_Previews: PreviewProvider {
  static var previews: some View {
    TelegramPreviewOverlay(
      viewModel: PreviewViewModel(),
      onSend: { _ in },
      onReport: { _, _ in },
      onDismiss: { }
    )
  }
}
