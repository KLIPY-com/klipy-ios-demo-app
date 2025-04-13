//  LazyGIFView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 16.01.25.
//

import SwiftUI
import Foundation
import SDWebImage
import SDWebImageSwiftUI

struct LazyGIFView: View {
  let item: GridItemLayout
  
  @State private var isPressed: Bool = false
  @State private var timer: Timer?
  @GestureState private var isPressing: Bool = false
  
  
  
  @State var isAnimating: Bool = true
  @State var impactFeedback = UIImpactFeedbackGenerator(style: .medium)
  @State var clickFeedback = UIImpactFeedbackGenerator(style: .heavy)
  @State var longPressInProgress: Bool = false
  @State private var itemFrame: CGRect = .zero
  
  @FocusState var isFocused: Bool
  
  var onClick: (() -> Void)
  
  @Binding var previewItem: GlobalMediaItem?
  
  init(item: GridItemLayout, previewItem: Binding<GlobalMediaItem?>, onClick: @escaping () -> Void, isFocused: FocusState<Bool>) {
    self.item = item
    self.onClick = onClick
    self._isFocused = isFocused
    self._previewItem = previewItem
  }
  
  var body: some View {
    Group {
      if item.type == "ad" {
        KlipyWebViewRepresentable.init(htmlString: item.url)
          .frame(width: item.newWidth, height: item.height)
          .padding(1)
      } else {
        AnimatedImage(url: URL(string: item.url), isAnimating: .constant(true)) {
          if let image = Image.fromBase64(item.previewUrl) {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: item.newWidth, height: item.height)
          }
        }
        .resizable()
        .transition(.fade)
        .playbackRate(1.0)
        .playbackMode(.bounce)
        .scaleEffect(isPressing ? 0.8 : 1.0)
        .animation(.spring(response: 0.9, dampingFraction: 0.9), value: isPressing)
        .overlay {
                  GeometryReader { geo in
                    Color.clear
                      .onAppear {
                        itemFrame = geo.frame(in: .global)
                      }
                  }

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
          
          if item.mp4Media != nil {
            impactFeedback.impactOccurred()
            previewItem = .init(item: item, frame: itemFrame)
          } else {
            clickFeedback.impactOccurred()
            onClick()
          }
        }
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .updating($isPressing) { _, state, _ in
              isFocused = false
              state = true
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .onChanged { _ in
              UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
              if isFocused {
                return
              }

              isFocused = false
              
              if !isPressed {
                isPressed = true
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                  impactFeedback.impactOccurred()
                  previewItem = .init(item: item, frame: itemFrame)
                  withAnimation {
                    isPressed = false
                  }
                }
              }
            }
            .onEnded { _ in
              isFocused = false
              timer?.invalidate()
              timer = nil
              withAnimation {
                isPressed = false
              }
            }
        )
        .frame(width: item.width, height: item.height)
        .padding(1)
      }
    }
  }
}


extension Image {
    /// Creates an Image from a base64 string using SDWebImage
    /// - Parameter base64String: The base64 encoded image string
    /// - Returns: An Image view, or nil if the string couldn't be converted
    static func fromBase64(_ string: String) -> Image? {
        let base64String = string.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")

        guard let data = Data(base64Encoded: base64String),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}

