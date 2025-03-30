//
//  ContentView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 10.01.25.
//

import SwiftUI

struct ContentView: View {
  @State var isPresented: Bool = true
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        NavigationLink(destination: ChatView(viewModel: .init(chatPreviewModel: ChatPreviewModel(
          name: "KLIPY",
          lastMessage: "Feel free to use all the fun content",
          time: "19:42",
          unreadCount: 0,
          isOnline: true,
          messages: Message.klipyExample
        )))) {
          ChatPreview(model: ChatPreviewModel(
            name: "KLIPY",
            lastMessage: "Feel free to use all the fun content",
            time: "19:42",
            unreadCount: 0,
            isOnline: true,
            messages: Message.klipyExample
          ))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
    
        NavigationLink(destination: ChatView(viewModel: .init(chatPreviewModel: ChatPreviewModel(
          name: "John Brown",
          lastMessage: "All good!",
          time: "23:11",
          unreadCount: 0,
          isOnline: true,
          messages: Message.johnBrowExample
        )))) {
          ChatPreview(model: ChatPreviewModel(
            name: "John Brown",
            lastMessage: "All good!",
            time: "23:11",
            unreadCount: 0,
            isOnline: true,
            messages: Message.johnBrowExample
          ))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
        
        NavigationLink(destination: ChatView(viewModel: .init(chatPreviewModel: ChatPreviewModel(
          name: "Sarah",
          lastMessage: "Sarah sent a sticker",
          time: "17:23",
          unreadCount: 0,
          isOnline: false,
          messages: Message.saraExample
        )))) {
          ChatPreview(model: ChatPreviewModel(
            name: "Sarah",
            lastMessage: "Sarah sent a sticker",
            time: "17:23",
            unreadCount: 0,
            isOnline: false,
            messages: Message.saraExample
          ))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
        
        NavigationLink(destination: ChatView(viewModel: .init(chatPreviewModel: ChatPreviewModel(
          name: "Alex",
          lastMessage: "hey, how's it going?",
          time: "13:02",
          unreadCount: 1,
          isOnline: true,
          messages: Message.alexExample
        )))) {
          ChatPreview(model: ChatPreviewModel(
            name: "Alex",
            lastMessage: "hey, how's it going?",
            time: "13:02",
            unreadCount: 1,
            isOnline: true,
            messages: Message.alexExample
          ))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
        
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
