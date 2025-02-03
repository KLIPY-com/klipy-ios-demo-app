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
  @State private var selectedCategory: MediaCategory?
  @State private var rows: [RowLayout] = []
  
  let onSend: (GridItemLayout) -> Void
  
  @State private var showToast = false
  
  @Environment(\.dismiss) private var dismiss
  private let calculator = MasonryLayoutCalculator()
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        MediaSearchBar(
          searchText: $searchText,
          selectedCategory: $selectedCategory,
          categories: viewModel.categories
        )
        .onChange(of: selectedCategory) {_, newCategory in
          if let categoryName = newCategory {
            switch categoryName.type {
            case .trending:
              Task {
                let items = try await viewModel.baseLoadTrendingItems()
                await MainActor.run {
                  viewModel.items = items
                }
              }
            case .recents:
              Task {
                let items = try await viewModel.baseLoadRecentItems()
                await MainActor.run {
                  viewModel.items = items
                }
              }
            case .none:
              categorySearchText = categoryName.name
            }
          } else {
            Task {
              let items = try await viewModel.baseLoadRecentItems()
              await MainActor.run {
                viewModel.items = items
              }
            }
          }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 12)
        .background(Color.init(hex: "#36383F"))
        
        mediaContent
        
        mediaTypeSelector
      }
      .toast(isPresenting: $showToast, duration: 5.0) {
        return AlertToast(
          displayMode: .banner(.pop),
          type: .regular,
          title: "🚓 Klipy moderators will review your report. \nThank you!"
        )
      }
      .navigationTitle(viewModel.currentType.displayName)
      .navigationBarTitleDisplayMode(.inline)
    }
    .task {
      await viewModel.loadRecentItems()
      await viewModel.fetchCategories()
    }
    .onChange(of: searchText) { _, newValue in
      Task {
        if newValue.isEmpty {
          let items = try await viewModel.baseLoadRecentItems()
          await MainActor.run {
            viewModel.items = items
          } 
        }
        await viewModel.searchItems(query: newValue)
      }
    }
    .onChange(of: categorySearchText) { _, newValue in
      Task {
        if newValue.isEmpty {
          let items = try await viewModel.baseLoadRecentItems()
          await MainActor.run {
            viewModel.items = items
          }
        }
        await viewModel.searchItems(query: newValue)
      }
    }
  }
  
  private var mediaContent: some View {
    ZStack {
      Color.init(hex: "#36383F")
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
              await MainActor.run {
                viewModel.items = []
              }
              //await viewModel.loadRecentItems()
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
      Color.init(hex: "#36383F")
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
          await viewModel.loadRecentItems()
        }
      }
    }) {
      Text(title)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(viewModel.currentType == type ? .black : Color.white)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
          viewModel.currentType == type ?
          Rectangle()
            .fill(Color.init(hex: "F8DC3B"))
            .cornerRadius(8)
          : nil
        )
    }
  }
}

#Preview {
  DynamicMediaView(onSend: { item in })
}
