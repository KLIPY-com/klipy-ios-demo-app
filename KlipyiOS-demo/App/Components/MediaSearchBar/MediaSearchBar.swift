//
//  MediaSearchBar.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 02.02.25.
//


import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MediaSearchBar: View {
  @Binding var searchText: String
  @Binding var selectedCategory: MediaCategory?
  let categories: [MediaCategory]
  
  var body: some View {
    ZStack {
      MediaSearchConfiguration.Colors.background
      
      HStack(spacing: MediaSearchConfiguration.Layout.horizontalSpacing) {
        navigationControl
        searchField
        clearButton
        categoriesView
      }
    }
    .frame(height: MediaSearchConfiguration.Layout.searchBarHeight)
    .padding(MediaSearchConfiguration.Layout.contentPadding)
    .background(MediaSearchConfiguration.Colors.background)
    .cornerRadius(MediaSearchConfiguration.Layout.cornerRadius)
  }
}

// MARK: - Subviews
private extension MediaSearchBar {
  var navigationControl: some View {
    Group {
      if selectedCategory != nil {
        backButton
      } else {
        searchIcon
      }
    }
    .frame(
      width: MediaSearchConfiguration.Layout.controlSize,
      height: MediaSearchConfiguration.Layout.controlSize
    )
    .contentShape(Rectangle())
  }
  
  var backButton: some View {
    Button(action: clearSelection) {
      Image(systemName: "chevron.left")
        .foregroundColor(MediaSearchConfiguration.Colors.icon)
    }
  }
  
  var searchIcon: some View {
    Image(systemName: "magnifyingglass")
      .foregroundColor(MediaSearchConfiguration.Colors.icon)
  }
  
  var searchField: some View {
    TextField("Search", text: $searchText)
      .textFieldStyle(PlainTextFieldStyle())
      .foregroundColor(MediaSearchConfiguration.Colors.text)
      .disabled(selectedCategory != nil)
      .frame(maxWidth: .infinity)
  }
  
  @ViewBuilder
  var clearButton: some View {
    if !searchText.isEmpty {
      Button(action: clearSelection) {
        Image(systemName: "xmark.circle.fill")
          .foregroundColor(MediaSearchConfiguration.Colors.icon)
          .frame(
            width: MediaSearchConfiguration.Layout.controlSize,
            height: MediaSearchConfiguration.Layout.controlSize
          )
      }
    }
  }
  
  @ViewBuilder
  var categoriesView: some View {
    if searchText.isEmpty {
      categoriesScrollView
    }
  }
  
  var categoriesScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: MediaSearchConfiguration.Layout.categorySpacing) {
        ForEach(categories) { category in
          CategoryIconButton(
            category: category,
            isSelected: selectedCategory?.name == category.name,
            action: { handleCategorySelection(category) }
          )
        }
      }
    }
    .frame(width: MediaSearchConfiguration.Layout.categoriesWidth)
    .overlay(gradientOverlay)
  }
  
  var gradientOverlay: some View {
    HStack {
      Spacer()
      LinearGradient(
        gradient: Gradient(colors: [
          MediaSearchConfiguration.Colors.background.opacity(0),
          MediaSearchConfiguration.Colors.background
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: MediaSearchConfiguration.Layout.gradientWidth)
    }
  }
  
  func clearSelection() {
    withAnimation {
      selectedCategory = nil
      searchText = ""
    }
  }
  
  func handleCategorySelection(_ category: MediaCategory) {
    withAnimation {
      if selectedCategory?.name == category.name {
        selectedCategory = nil
      } else {
        selectedCategory = category
      }
    }
  }
}

// MARK: - Preview
#Preview {
  MediaSearchBar(
    searchText: .constant(""),
    selectedCategory: .constant(nil),
    categories: [
      MediaCategory(name: "Trending", type: .trending),
      MediaCategory(name: "Recent", type: .recents)
    ]
  )
  .padding()
  .background(Color.black)
}
