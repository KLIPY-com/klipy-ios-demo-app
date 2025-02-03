import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import AVKit

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
  @State private var isPlaying: Bool = false
  @State private var player: AVPlayer?
  @State private var isVideoURLValid: Bool = false
  
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
              if let mp4UrlString = selectedItem.item.mp4Media?.mp4?.url,
                 let url = URL(string: mp4UrlString),
                 isVideoURLValid,
                 let videoPlayer = player {
                
                VideoPlayer(player: videoPlayer) {
                  Button {
                    if isPlaying {
                      videoPlayer.pause()
                    } else {
                      videoPlayer.seek(to: .zero)
                      videoPlayer.play()
                    }
                    isPlaying.toggle()
                  } label: {
                    Image(systemName: isPlaying ? "" : "play")
                      .foregroundColor(.white)
                      .padding()
                  }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width * 0.8, height: targetSize.height * 1.5)
                .onDisappear {
                  videoPlayer.pause()
                  isPlaying = false
                }
                
              } else {
                AnimatedImage(url: URL(string: selectedItem.item.highQualityUrl)) {
                  if let image = Image.fromBase64(selectedItem.item.previewUrl) {
                    image
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: targetSize.width, height: targetSize.height)
                  }
                }
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
              setupVideoPlayer(for: selectedItem.item)
            }
            .clipShape(.rect(cornerRadius: 12, style: .continuous))
            .menuOverlay(isPresented: $showingMenu, onAction: handleMenuAction)
            
            Spacer()
          }
        }
      }
    }
  }
  
  private func setupVideoPlayer(for selectedItem: GridItemLayout) {
    if let mp4UrlString = selectedItem.mp4Media?.mp4?.url,
       let url = URL(string: mp4UrlString),
       UIApplication.shared.canOpenURL(url) {
      
      let playerItem = AVPlayerItem(url: url)
      playerItem.tracks.forEach { track in
        track.isEnabled = true
      }
      
      self.player = AVPlayer(playerItem: playerItem)
      self.isVideoURLValid = true
      
      // Set up player
      player?.actionAtItemEnd = .none
      try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
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
