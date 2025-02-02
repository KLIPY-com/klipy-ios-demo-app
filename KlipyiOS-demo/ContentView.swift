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
        NavigationLink(destination: ChatView()) {
          ChatPreview(model: ChatPreviewModel(
            name: "John Brown",
            lastMessage: "Hi, how's it going?",
            time: "19.02.14",
            unreadCount: 2,
            isOnline: true
          ), theme: .default)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
        
        Spacer()
      }
      .background(Color.init(hex: "#19191C"))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        // Left Menu Button
        ToolbarItem(placement: .topBarLeading) {
          HStack {
            Spacer().frame(width: 10)
            Button(action: {
              print("Search")
            }) {
              Circle()
                .fill(Color(hex: "F8DC3B"))
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
              Circle()
                .fill(Color(hex: "F8DC3B"))
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
