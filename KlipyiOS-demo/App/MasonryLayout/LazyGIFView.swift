//
//  LazyGIFView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import Foundation
import SDWebImage
import SDWebImageSwiftUI
import SwiftUI

/// A view responsible for rendering a GIF or media item in a lazy loading manner.
/// `LazyGIFView` is used to display media items (GIFs, clips, or ads) in a grid layout, with support for tapping, long-pressing,
/// and visual feedback for user interaction. It supports animations, scaling effects, and integrates haptic feedback on actions.
///
/// The view handles both interactive and non-interactive media items, such as advertisements and GIFs, providing a seamless
/// and smooth experience for users.
struct LazyGIFView: View {

  /// The media item to be displayed in the view.
  /// This item is passed to the view to dynamically render the GIF, video, or ad in the correct layout.
  let item: GridItemLayout

  /// A state variable that tracks whether the media item is being pressed by the user.
  /// Used for providing visual feedback (scale effect) during the press gesture.
  @State private var isPressed: Bool = false

  /// A timer used for detecting long presses.
  /// This timer triggers when a user holds the item for a longer period (e.g., 0.5 seconds), and initiates the related actions.
  @State private var timer: Timer?

  /// A gesture state variable that tracks whether the user is pressing on the media item.
  /// This is used to dynamically adjust the visual scale of the item when the user is pressing.
  @GestureState private var isPressing: Bool = false

  /// A state variable to control the animation status of the GIF.
  /// Used to determine whether the GIF should be continuously animated or paused.
  @State var isAnimating: Bool = true

  /// Haptic feedback generators for user interaction.
  /// Provides feedback on user actions like pressing or clicking.
  @State var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
  @State var clickFeedback = UIImpactFeedbackGenerator(style: .heavy)

  /// A flag indicating whether a long press is in progress.
  @State var longPressInProgress: Bool = false

  /// The frame of the item, used for positioning and animation purposes.
  @State private var itemFrame: CGRect = .zero

  /// A focus state that tracks the focus status of the item for keyboard and UI interaction purposes.
  @FocusState var isFocused: Bool

  /// A closure to be executed when the media item is clicked.
  var onClick: (() -> Void)

  /// A binding to update the preview item that is currently being previewed.
  @Binding var previewItem: GlobalMediaItem?

  /// Custom initializer for `LazyGIFView` to pass necessary data, like the item, preview item, and click action closure.
  init(
    item: GridItemLayout, previewItem: Binding<GlobalMediaItem?>, onClick: @escaping () -> Void,
    isFocused: FocusState<Bool>
  ) {
    self.item = item
    self.onClick = onClick
    self._isFocused = isFocused
    self._previewItem = previewItem
  }

  var body: some View {
    Group {
      if item.type == "ad" {
        /// If the item is an advertisement, render it as a web view using its URL.
        KlipyWebViewRepresentable.init(htmlString: item.url)
          .frame(width: item.width, height: item.height)
          .padding(1)
      } else {
        /// Otherwise, render a GIF or media item using `AnimatedImage` from `SDWebImage`.
        AnimatedImage(url: URL(string: item.url), isAnimating: .constant(true)) {
          if let image = Image.fromBase64(item.previewUrl) {
            image
              .resizable()
              .frame(width: item.width, height: item.height)
              .clipped()
          }
        }
        .resizable()
        .transition(.fade)  // Apply fade transition for smooth loading and display.
        .playbackRate(1.0)  // Set the playback rate of the GIF.
        .playbackMode(.bounce)  // Apply a bounce effect when the GIF is played.
        .scaleEffect(isPressing ? 0.8 : 1.0)  // Scale effect for press interaction.
        .animation(.spring(response: 0.9, dampingFraction: 0.9), value: isPressing)  // Spring animation on press.
        .overlay {
          GeometryReader { geo in
            Color.clear
              .onAppear {
                itemFrame = geo.frame(in: .global)  // Capture the global frame of the item for positioning.
              }
          }

          /// If the item is a video clip, show the title overlay.
          if item.type == "clip" {
            ZStack(alignment: .topLeading) {
              VStack {
                HStack {
                  Image(systemName: "speaker.slash.fill")
                    .foregroundColor(.white)
                    .padding(.leading, 2)
                  Spacer()
                }

                VStack(alignment: .leading) {
                  Spacer()
                  HStack {
                    Text(item.title)
                      .foregroundColor(.white)
                      .font(.footnote)
                      .fontWeight(.medium)
                      .lineLimit(2)
                      .multilineTextAlignment(.leading)
                      .truncationMode(.tail)
                      .padding(.leading, 2)
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                  }
                }
              }
              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          }
        }
        .onTapGesture {
          isFocused = false

          // On tap, check if it's a video (mp4Media). If so, provide a preview item.
          if item.mp4Media != nil {
            impactFeedback.impactOccurred()  // Provide haptic feedback for a video tap.
            previewItem = .init(item: item, frame: itemFrame)  // Set the preview item for the media.
          } else {
            clickFeedback.impactOccurred()  // Provide haptic feedback for other types of media.
            onClick()  // Trigger the custom click action.
          }
        }
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)  // Detect drag gestures to allow for long press detection.
            .updating($isPressing) { _, state, _ in
              isFocused = false
              state = true
              UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onChanged { _ in
              UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
              if isFocused {
                return
              }

              isFocused = false

              if !isPressed {
                isPressed = true
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                  impactFeedback.impactOccurred()  // Trigger long press feedback.
                  previewItem = .init(item: item, frame: itemFrame)  // Set preview item on long press.
                  withAnimation {
                    isPressed = false
                  }
                }
              }
            }
            .onEnded { _ in
              isFocused = false
              timer?.invalidate()  // Stop the timer when the drag ends.
              timer = nil
              withAnimation {
                isPressed = false
              }
            }
        )
        .clipped()
        .frame(width: item.width, height: item.height)  // Ensure the GIF or media fits in the given frame.
        .padding(1)
      }
    }
  }
}

extension Image {
  /// Creates an Image from a base64 string using SDWebImage.
  /// This extension helps in converting a base64-encoded image string into a usable `Image` view.
  /// - Parameter base64String: The base64 encoded image string.
  /// - Returns: An `Image` view, or `nil` if the string couldn't be converted into a valid image.
  static func fromBase64(_ string: String) -> Image? {
    let base64String = string.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")

    guard let data = Data(base64Encoded: base64String),
      let uiImage = UIImage(data: data)
    else {
      return nil
    }
    return Image(uiImage: uiImage)
  }
}
