//
//  DynamicMediaView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI
import AlertToast

struct DynamicMediaView: View {
  @Bindable private var viewModel = DynamicMediaViewModel()
  
  @State private var searchText = ""
  @State private var selectedCategory: MediaCategory?
  @State private var rows: [RowLayout] = []
  
  @FocusState private var isSearchFocused: Bool
  
  let onSend: (GridItemLayout) -> Void
    
  @Binding var previewItem: GlobalMediaItem?
  
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
      .contentShape(Rectangle())
      .onTapGesture {
        isSearchFocused = false
      }
      .navigationTitle("")
      .navigationBarTitleDisplayMode(.inline)
    }
    .task {
      await viewModel.checkServicesHealth()
      await viewModel.fetchCategories()
      await viewModel.initialLoad()
    }
    .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
      if shouldDismiss {
        dismiss()
      }
    }
    .onChange(of: searchText) { _, newValue in
      Task { @MainActor in
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
      Task { @MainActor in
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
        hasNext: viewModel.hasMorePages,
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
//        onReport: { reportedModel, url, reason in
//          showToast = true
//          guard let mediaModel = viewModel.getMediaItem(by: reportedModel.id) else { return }
//          Task {
//            try await viewModel.reportItem(item: mediaModel, reason: reason.rawValue)
//          }
//        },
        isFocused: _isSearchFocused,
        previewItem: $previewItem
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
    let isAvailable = isTypeAvailable(type)
    
    return Button(action: {
      if isAvailable {
        withAnimation {
          viewModel.switchToType(type)
          searchText = ""
          Task {
            await viewModel.initialLoad()
          }
        }
      }
    }) {
      Text(title)
        .font(.system(size: 17, weight: .bold))
        .foregroundColor(buttonTextColor(for: type, isAvailable: isAvailable))
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
          buttonBackground(for: type, isAvailable: isAvailable)
        )
    }
    .disabled(!isAvailable)
  }
  
  private func buttonTextColor(for type: MediaType, isAvailable: Bool) -> Color {
    if !isAvailable {
      return .gray
    }
    return viewModel.currentType == type ? .black : .white
  }
  
  private func buttonBackground(for type: MediaType, isAvailable: Bool) -> some View {
    Group {
      if viewModel.currentType == type && isAvailable {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color(hex: "F8DC3B"))
      } else {
        EmptyView()
      }
    }
  }
  
  private func isTypeAvailable(_ type: MediaType) -> Bool {
    guard let availability = viewModel.mediaAvailability else { return true }
    
    switch type {
    case .gifs: return availability.gifs.isAlive
    case .clips: return availability.clips.isAlive
    case .stickers: return availability.stickers.isAlive
    case .ad: return true
    }
  }
}
