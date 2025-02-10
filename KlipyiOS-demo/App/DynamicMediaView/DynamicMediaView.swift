//
//  DynamicMediaView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI
import AlertToast

actor SearchDebouncer {
  private var task: Task<Void, Never>?
  
  func debounce(
    for duration: Duration = .milliseconds(300),
    action: @escaping () async -> Void
  ) {
    task?.cancel()
    task = Task {
      try? await Task.sleep(for: duration)
      guard !Task.isCancelled else { return }
      await action()
    }
  }
}

struct DynamicMediaView: View {
  @Bindable private var viewModel = DynamicMediaViewModel()
  
  @State private var searchText = ""
  @State private var selectedCategory: MediaCategory?
  @State private var rows: [RowLayout] = []
  
  @FocusState private var isSearchFocused: Bool
  
  let onSend: (GridItemLayout) -> Void
  
  @State private var showToast = false
  
  @Environment(\.dismiss) private var dismiss
  var searchDebouncer = SearchDebouncer()
  
  private let calculator = MasonryLayoutCalculator()
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        MediaSearchBar(
          searchText: $searchText,
          selectedCategory: $viewModel.activeCategory,
          isFocused: _isSearchFocused,
          categories: viewModel.categories
        )
        .onChange(of: viewModel.activeCategory) { _, newCategory in
          guard let category = newCategory else {
            return
          }
  
          viewModel.resetState()
          switch category.type {
          case .trending:
            Task {
              let items = try await viewModel.baseLoadTrendingItems()
              viewModel.items = items
            }
          case .recents:
            Task {
              let items = try await viewModel.baseLoadRecentItems()
              viewModel.items = items
            }
          case .none:
            viewModel.categorySearchText = category.name
          }
        }
        .padding(.bottom, 12)
        .padding(.horizontal, 12)
        .padding(.top, 18)
        .background(Color(hex: "#36383F"))
        
        mediaContent
        
        mediaTypeSelector
      }
      .toast(isPresenting: $showToast, duration: 5.0) {
        AlertToast(
          displayMode: .banner(.pop),
          type: .regular,
          title: "🚓 Klipy moderators will review your report. \nThank you!"
        )
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isSearchFocused = false
      }
      .navigationTitle("")
      .navigationBarTitleDisplayMode(.inline)
    }
    .task {
      await viewModel.fetchCategories()
      await viewModel.initialLoad()
    }
    .onChange(of: searchText) { _, newValue in
      Task {
        await searchDebouncer.debounce {
          if newValue.isEmpty {
            await viewModel.initialLoad()
          } else {
            await viewModel.searchItems(query: newValue)
          }
        }
      }
    }
    .onChange(of: viewModel.categorySearchText) { _, newValue in
      Task {
        if newValue.isEmpty {
          return
        } else {
          await viewModel.searchItems(query: newValue)
        }
      }
    }
  }
  
  private var mediaContent: some View {
    ZStack {
      Color(hex: "#36383F")
      MasonryGridView(
        rows: rows,
        onLoadMore: {
          Task {
            await viewModel.loadNextPageIfNeeded()
          }
        },
        previewLoaded: { model in
          Task {
            guard let mediaItem = viewModel.getMediaItem(by: model.id) else { return }
            try await viewModel.trackView(for: mediaItem)
          }
        },
        onSend: { mediaItem in
          onSend(mediaItem)
          if let item = viewModel.getMediaItem(by: mediaItem.id) {
            Task {
              try await viewModel.trackShare(for: item)
            }
          }
        },
        onReport: { url, reason in
          showToast = true
        },
        isFocused: _isSearchFocused
      )
      .padding(.horizontal, 10)
      .frame(maxWidth: .infinity)
    }
    .onChange(of: viewModel.items) { newValue in
      rows = calculator.createRows(from: newValue)
    }
  }
  
  private var mediaTypeSelector: some View {
    ZStack {
      Color(hex: "#36383F")
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
    .safeAreaInset(edge: .bottom) {
      Color.clear.frame(height: 15)
    }
  }
  
  private func mediaTypeButton(_ title: String, type: MediaType) -> some View {
    Button(action: {
      withAnimation {
        viewModel.switchToType(type)
        searchText = ""
        Task {
          await viewModel.initialLoad()
        }
      }
    }) {
      Text(title)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(viewModel.currentType == type ? .black : .white)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
          viewModel.currentType == type ?
          RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "F8DC3B"))
          : nil
        )
    }
  }
}

#Preview {
  DynamicMediaView(onSend: { item in })
}
