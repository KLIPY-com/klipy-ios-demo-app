//
//  ChatPreviewCell.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import SwiftUI

struct ChatPreview: View {
  let name: String
  let lastMessage: String
  let time: String
  let unreadCount: Int
  
  init(
    name: String,
    lastMessage: String,
    time: String,
    unreadCount: Int = 2
  ) {
    self.name = name
    self.lastMessage = lastMessage
    self.time = time
    self.unreadCount = unreadCount
  }
  
  var body: some View {
    HStack(spacing: 12) {
      ZStack(alignment: .bottomTrailing) {
        Circle()
          .fill(Color(.systemGray5))
          .frame(width: 50, height: 50)
          .overlay(
            Image(systemName: "person.fill")
              .foregroundColor(.gray)
              .font(.system(size: 24))
          )
        
        Circle()
          .fill(Color.green)
          .frame(width: 12, height: 12)
          .overlay(
            Circle()
              .stroke(Color.white, lineWidth: 2)
          )
      }
      
      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Text(name)
            .font(.headline)
          
          Spacer()
          
          Text(time)
            .font(.caption)
            .foregroundColor(.gray)
        }
        
        HStack {
          Text(lastMessage)
            .font(.subheadline)
            .foregroundColor(Color(hex: "1E68D7"))
            .lineLimit(1)
          
          if unreadCount > 0 {
            Spacer()
            
            ZStack {
              Circle()
                .fill(Color(hex: "1E68D7"))
                .frame(width: 20, height: 20)
              
              Text("\(unreadCount)")
                .font(.caption2)
                .bold()
                .foregroundColor(.white)
            }
          }
        }
      }
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
    .background(Color(red: 41/255, green: 46/255, blue: 50/255))
  }
}

// Color extension for hex colors
extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

struct ChatPreviewCell_Previews: PreviewProvider {
  static var previews: some View {
    ChatPreview(
      name: "John",
      lastMessage: "Seen",
      time: "19.02.14",
      unreadCount: 2
    )
  }
}
