//
//  ContentView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 10.01.25.
//

import SwiftUI

struct ContentView: View {
  @State var isPresented: Bool = true
    
  let chatModels = [
    ChatPreviewModel(
      name: "KLIPY",
      lastMessage: "Feel free to use all the fun content",
      time: "19:42",
      unreadCount: 0,
      isOnline: true,
      messages: Message.klipyExample
    ),
    ChatPreviewModel(
      name: "John Brown",
      lastMessage: "All good!",
      time: "23:11",
      unreadCount: 0,
      isOnline: true,
      messages: Message.johnBrowExample
    ),
    ChatPreviewModel(
      name: "Sarah",
      lastMessage: "Sarah sent a sticker",
      time: "17:23",
      unreadCount: 0,
      isOnline: false,
      messages: Message.saraExample
    ),
    ChatPreviewModel(
      name: "Alex",
      lastMessage: "hey, how's it going?",
      time: "13:02",
      unreadCount: 1,
      isOnline: true,
      messages: Message.alexExample
    )
  ]

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        ForEach(chatModels, id: \.name) { chatModel in
          NavigationLink {
            ChatView(viewModel: .init(chatPreviewModel: chatModel))
          } label: {
            // The entire row becomes the clickable area
            ChatPreview(model: chatModel)
              .contentShape(Rectangle()) // This ensures the entire area is tappable
              .padding(.top, 1)
          }
          .buttonStyle(PlainButtonStyle())
        }
        
        Spacer()
      }
      .background(Color.init(hex: "#19191C"))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          HStack {
            Spacer().frame(width: 10)
            Button(action: {
              print("Search")
            }) {
              Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(hex: "F8DC3B"))
                .frame(width: 20, height: 20)
            }
          }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          HStack {
            Spacer().frame(width: 10)
            Button(action: {
              print("Search")
            }) {
              Image(systemName: "line.horizontal.3")
                .foregroundColor(Color(hex: "F8DC3B"))
                .frame(width: 20, height: 20)
            }
          }
        }
      }
    }
  }
}

// Preview
#Preview {
  ContentView()
}
