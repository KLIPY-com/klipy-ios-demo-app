//
//  GifGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI
import AlertToast

struct DynamicMediaView: View {
  @Bindable private var viewModel = DynamicMediaViewModel()
  
  @State private var searchText = ""
  @State private var categorySearchText = ""
  @State private var selectedCategory: Category?
  @State private var rows: [RowLayout] = []
  
  let onSend: (GridItemLayout) -> Void
  
  @State private var showToast = false
  
  @Environment(\.dismiss) private var dismiss
  private let calculator = MasonryLayoutCalculator()
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        ContentSearchBar(
          searchText: $searchText,
          selectedCategory: $selectedCategory,
          categories: viewModel.categories
        )
        .onChange(of: selectedCategory) {_, newCategory in
          if let categoryName = newCategory?.name {
            categorySearchText = categoryName
          } else {
            searchText = ""
            categorySearchText = ""
          }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 12)
        
        mediaContent
        
        mediaTypeSelector
      }
      .toast(isPresenting: $showToast) {
        return AlertToast(
          displayMode: .banner(.pop),
          type: .regular,
          title: "🚓 Klipy moderators will review your report. \nThank you!"
        )
      }
      .navigationTitle(viewModel.currentType.displayName)
      .navigationBarTitleDisplayMode(.inline)
      .background(Color(red: 41/255, green: 46/255, blue: 50/255))
    }
    .task {
      await viewModel.loadTrendingItems()
      await viewModel.fetchCategories()
    }
    .onChange(of: searchText) { _, newValue in
      Task {
        await viewModel.searchItems(query: newValue)
      }
    }
    .onChange(of: categorySearchText) { _, newValue in
      Task {
        await viewModel.searchItems(query: newValue)
      }
    }
  }
  
  private var mediaContent: some View {
    ZStack {
      Color(red: 41/255, green: 46/255, blue: 50/255)
      MasonryGridView(
        rows: rows,
        onLoadMore: {
          Task {
            await viewModel.loadNextPageIfNeeded()
          }
        },
        onSend: { mediaItem in
          onSend(mediaItem)
          
          guard let mediaItem = viewModel.getMediaItem(by: mediaItem.id) else {
            return
          }
          
          Task {
            try await viewModel.trackShare(for: mediaItem)
          }
        },
        onReport: { url, reason in
          showToast = true
        }
      )
      .padding(.horizontal, 10)
      .frame(maxWidth: .infinity)
    }
    .onChange(of: viewModel.items) { _, _ in
      rows = calculator.createRows(from: viewModel.items)
    }
  }
  
  private var searchBar: some View {
    HStack(spacing: 8) {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.gray)
        TextField("Search \(viewModel.currentType.displayName)", text: $searchText)
          .font(.system(size: 16))
        
        if !searchText.isEmpty {
          Button(action: {
            searchText = ""
            Task {
              await viewModel.loadTrendingItems()
            }
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
        }
      }
      .padding(8)
      .background(Color(.systemGray6))
      .cornerRadius(8)
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
    .background(Color.white)
  }
  
  private var mediaTypeSelector: some View {
    ZStack {
      Color(red: 41/255, green: 46/255, blue: 50/255)
        .ignoresSafeArea()
      
      HStack(spacing: 20) {
        mediaTypeButton("GIFs", type: .gifs)
        mediaTypeButton("Clips", type: .clips)
        mediaTypeButton("Stickers", type: .stickers)
      }
      .padding(.top, 10)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 44)
  }
  
  private func mediaTypeButton(_ title: String, type: MediaType) -> some View {
    Button(action: {
      withAnimation {
        viewModel.switchToType(type)
        searchText = ""
        Task {
          await viewModel.loadTrendingItems()
        }
      }
    }) {
      Text(title)
        .font(.system(size: 17))
        .foregroundColor(viewModel.currentType == type ? .white : Color.white.opacity(0.5))
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
          viewModel.currentType == type ?
          Capsule()
            .fill(Color(red: 52/255, green: 120/255, blue: 246/255))
          : nil
        )
    }
  }
}

#Preview {
  DynamicMediaView(onSend: { item in })
}
