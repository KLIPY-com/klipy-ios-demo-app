//
//  Category.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 19.01.25.
//


import SwiftUI

struct Category: Identifiable, Equatable {
  let name: String
  let id = UUID()
  
  /// SF Symbol name
  let icon: String
}

struct ContentSearchBar: View {
  @Binding var searchText: String
  @Binding var selectedCategory: Category?
  
  let categories = [
    Category(name: "love", icon: "heart.fill"),
    Category(name: "yes", icon: "hand.thumbsup.fill"),
    Category(name: "no", icon: "hand.thumbsdown.fill"),
    Category(name: "happy", icon: "face.smiling.fill"),
    Category(name: "funny", icon: "face.smiling.inverse"),
    Category(name: "surprised", icon: "face.dashed.fill"),
    Category(name: "sad", icon: "face.frown.fill"),
    Category(name: "angry", icon: "face.disguised.fill"),
    Category(name: "huh", icon: "questionmark.circle.fill"),
    Category(name: "doubt", icon: "exclamationmark.circle.fill"),
    Category(name: "silly", icon: "face.smiling.inverse.fill")
  ]
  
  var body: some View {
    HStack(spacing: 12) {
      // Toggle between back button and search icon based on category selection
      if selectedCategory != nil {
        Button(action: {
          withAnimation {
            selectedCategory = nil
            searchText = ""
          }
        }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.gray)
            .frame(width: 24)
        }
      } else {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.gray)
          .frame(width: 24)
      }
      
      TextField("Search", text: $searchText)
        .textFieldStyle(PlainTextFieldStyle())
        .foregroundColor(.white)
        .disabled(selectedCategory != nil)
      
      if !searchText.isEmpty {
        Button(action: {
          searchText = ""
          selectedCategory = nil
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
        }
      }
      
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
                Image(systemName: category.icon)
                  .foregroundColor(selectedCategory?.name == category.name ? .blue : .gray)
                  .font(.system(size: 20))
              }
            }
          }
          .padding(.trailing, 8)
        }
      }
    }
    .padding(.bottom, 10)
    .padding(.horizontal, 8)
    .background(Color(red: 24/255, green: 28/255, blue: 31/255))
    .cornerRadius(20)
  }
}

#Preview {
  @Previewable @State var searchText: String = ""
  @Previewable @State var selectedCategory: Category?
  
  return ZStack {
    Color.black.edgesIgnoringSafeArea(.all)
    ContentSearchBar(searchText: $searchText, selectedCategory: $selectedCategory)
  }
}
