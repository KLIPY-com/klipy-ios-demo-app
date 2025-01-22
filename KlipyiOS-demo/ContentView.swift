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
          ChatPreview(
            name: "John Brown",
            lastMessage: "Hi, how's it going?",
            time: "19.02.14",
            unreadCount: 2
          )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 1)
        
        Spacer()
      }
      .background(Color(red: 41/255, green: 46/255, blue: 50/255))
//      .sheet(isPresented: $isPresented, content: {
//        DynamicMediaView()
//      })
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        // Left Menu Button
        ToolbarItem(placement: .topBarLeading) {
          Button(action: {
            print("Search")
          }) {
            Image(systemName: "line.3.horizontal")
              .foregroundColor(Color(hex: "1E68D7"))
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            print("Search")
          }) {
            Image(systemName: "magnifyingglass")
              .foregroundColor(Color(hex: "1E68D7"))
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
