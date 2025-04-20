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
  var viewModel: GlobalMediaItem?
  
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
          .ignoresSafeArea()
          .onTapGesture {
            onDismiss()
          }
        
        if let selectedItem = viewModel?.item {
          let screenSize = geometry.size
          let targetSize = calculateTargetSize(
            originalSize: CGSize(
              width: selectedItem.width,
              height: selectedItem.height
            ),
            screenSize: screenSize,
            isMenuShown: showingMenu
          )
          
          VStack {
            Spacer()
            
            Group {
              if let mp4UrlString = selectedItem.mp4Media?.mp4?.url,
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
                .onAppear {
                  videoPlayer.play()
                  isPlaying.toggle()
                }
                .onDisappear {
                  videoPlayer.pause()
                  isPlaying = false
                }
                
              } else {
                AnimatedImage(url: URL(string: selectedItem.highQualityUrl)) {
                  if let image = Image.fromBase64(selectedItem.previewUrl) {
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
            .onAppear {
              showingMenu = true
              setupVideoPlayer(for: selectedItem)
            }
            .clipShape(.rect(cornerRadius: 12, style: .continuous))
            .menuOverlay(isPresented: $showingMenu, onAction: handleMenuAction)
            Spacer()
          }
        }
      }
    }
  }
  
  private func calculateTargetSize(
    originalSize: CGSize,
    screenSize: CGSize,
    isMenuShown: Bool
  ) -> CGSize {
    /// Maximum width is device width - 20 (10 margin from left, 10 margin from right)
    let maxWidth = screenSize.width - 20
    
    /// Maximum height is 60% of the screen height
    let maxHeight = screenSize.height * 0.6
    
    /// Calculate scale to fit within constraints while maintaining aspect ratio
    let widthRatio = maxWidth / originalSize.width
    let heightRatio = maxHeight / originalSize.height
    
    /// Use the smaller ratio to ensure both dimensions fit within constraints
    let scale = min(widthRatio, heightRatio)
    
    /// Calculate final dimensions
    let finalWidth = originalSize.width * scale
    let finalHeight = originalSize.height * scale
    
    return CGSize(
      width: finalWidth,
      height: finalHeight
    )
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
      
      NotificationCenter.default.addObserver(
        forName: .AVPlayerItemDidPlayToEndTime,
        object: playerItem,
        queue: .main
      ) { [weak player] _ in
        player?.seek(to: .zero)
        player?.play()
      }
    }
  }
  
  private func handleMenuAction(_ action: MenuAction) {
    guard let selectedItem = viewModel?.item else {
      return
    }
    
    withAnimation(.spring(response: 0.3)) {
      showingMenu = false
      onDismiss()
    }
    
    switch action {
    case .send:
      onSend(selectedItem)
    case .report(let reason):
      onReport(selectedItem.url, reason)
    }
  }
  
//  private func calculateTargetSize(
//    originalSize: CGSize,
//    screenSize: CGSize,
//    isMenuShown: Bool
//  ) -> CGSize {
//    let maxWidth = screenSize.width * 0.9 * (isMenuShown ? 0.8 : 0.9)
//    let maxHeight = screenSize.height * (isMenuShown ? 0.6 : 0.7)
//    
//    let widthRatio = maxWidth / originalSize.width
//    let heightRatio = maxHeight / originalSize.height
//    
//    let scale = min(widthRatio, heightRatio)
//    
//    return CGSize(
//      width: originalSize.width * scale,
//      height: originalSize.height * scale
//    )
//  }
}
