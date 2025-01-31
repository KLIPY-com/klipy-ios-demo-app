//
//  Category.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 19.01.25.
//


import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct Category: Identifiable, Equatable {
  let name: String
  let id = UUID()
  let iconUrl: String
  
  init(name: String) {
    self.name = name
    self.iconUrl = "\(CATEGORY_FATCH_URL)\(name).png"
  }
}


struct ContentSearchBar: View {
  @Binding var searchText: String
  @Binding var selectedCategory: Category?
  let categories: [Category]
  
  var body: some View {
    ZStack {
      Color(red: 24/255, green: 28/255, blue: 31/255)
      HStack(spacing: 12) {
        // Leading section with search/back icon
        Group {
          if selectedCategory != nil {
            Button(action: {
              withAnimation {
                selectedCategory = nil
                searchText = ""
              }
            }) {
              Image(systemName: "chevron.left")
                .foregroundColor(.gray)
            }
          } else {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.gray)
          }
        }
        .frame(width: 24, height: 24)
        .contentShape(Rectangle())
        
        // Search TextField
        TextField("Search", text: $searchText)
          .textFieldStyle(PlainTextFieldStyle())
          .foregroundColor(.white)
          .disabled(selectedCategory != nil)
          .frame(maxWidth: .infinity)
        
        // Clear button
        if !searchText.isEmpty {
          Button(action: {
            searchText = ""
            selectedCategory = nil
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
              .frame(width: 24, height: 24)
          }
        }
        
        // Category icons
        if searchText.isEmpty {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(categories) { category in
                Button(action: {
                  withAnimation {
                    if selectedCategory?.name == category.name {
                      selectedCategory = nil
                    } else {
                      selectedCategory = category
                    }
                  }
                }) {
                  WebImage(url: URL(string: category.iconUrl))
                    .resizable()
                    .renderingMode(.template)
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(selectedCategory?.name == category.name ? .blue : .gray)
                }
                .frame(width: 22, height: 22)
              }
            }
          }
          // Constrain scroll view width and add gradient
          .frame(width: 165)  // Adjust this value based on your needs
          .overlay(
            HStack {
              Spacer()
              LinearGradient(
                gradient: Gradient(colors: [
                  Color(red: 24/255, green: 28/255, blue: 31/255).opacity(0),
                  Color(red: 24/255, green: 28/255, blue: 31/255)
                ]),
                startPoint: .leading,
                endPoint: .trailing
              )
              .frame(width: 20)
            }
          )
        }
      }
    }
    .frame(height: 28)
    .padding(.horizontal, 12)
    .padding(.vertical, 12)
    .background(Color(red: 24/255, green: 28/255, blue: 31/255))
    .cornerRadius(20)
  }
}

#Preview {
  
}
