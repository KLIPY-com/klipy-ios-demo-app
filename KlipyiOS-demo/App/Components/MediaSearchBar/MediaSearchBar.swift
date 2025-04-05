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
  
  @FocusState var isFocused: Bool
  
  let categories: [MediaCategory]
  
  @Binding var sheetHeight: SheetHeight
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        HStack(spacing: MediaSearchConfiguration.Layout.horizontalSpacing) {
          navigationControl
          searchField
          clearButton
          categoriesView
        }
      }
      .padding(MediaSearchConfiguration.Layout.contentPadding)
      .background(.clear)
      .cornerRadius(MediaSearchConfiguration.Layout.cornerRadius)
      .frame(maxWidth: .infinity)
      .onChange(of: isFocused) { oldValue, newValue in
        if newValue {
          expandToFullHeight()
        }
      }
    }
    .frame(height: 45)
  }
}

// MARK: - Subviews
private extension MediaSearchBar {
  var navigationControl: some View {
    Group {
      if searchText.isEmpty {
        searchIcon
      } else {
        backButton
      }
    }
    .frame(
      width: MediaSearchConfiguration.Layout.controlSize,
      height: MediaSearchConfiguration.Layout.controlSize
    )
    .contentShape(Rectangle())
  }
  
  var backButton: some View {
    Button(action: clearSearchOnly) {
      Image(systemName: "chevron.left")
        .foregroundColor(MediaSearchConfiguration.Colors.icon)
    }
  }
  
  var searchIcon: some View {
    Image(systemName: "magnifyingglass")
      .foregroundColor(.white)
      .padding(8)
      .foregroundColor(MediaSearchConfiguration.Colors.icon)
  }
  
  var searchField: some View {
    TextField("", text: $searchText)
      .textFieldStyle(PlainTextFieldStyle())
      .foregroundColor(MediaSearchConfiguration.Colors.text)
      .placeholder(when: searchText.isEmpty) {
        Text("Search")
          .foregroundColor(MediaSearchConfiguration.Colors.text.opacity(0.5))
      }
      .focused($isFocused)
      .frame(maxWidth: .infinity)
      .onTapGesture {
        expandToFullHeight()
      }
  }
  
  @ViewBuilder
  var clearButton: some View {
    if !searchText.isEmpty {
      Button(action: clearSearchOnly) {
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
  
  func clearSearchOnly() {
    withAnimation {
      searchText = ""
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
      clearSearchOnly()
      if selectedCategory?.name == category.name {
        return
      } else {
        selectedCategory = category
      }
    }
  }
  
  private func expandToFullHeight() {
    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
      sheetHeight = .full
    }
  }
}

extension View {
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content
  ) -> some View {
    ZStack(alignment: alignment) {
      placeholder().opacity(shouldShow ? 1 : 0)
      self
    }
  }
}
