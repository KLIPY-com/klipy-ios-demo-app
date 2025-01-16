//
//  GifGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

struct DynamicMediaView: View {
  // TODO: We need to fix memory efficancy here
  // We don't need to have 3 observable here
  // We just need to have one which will have inside 3 different use case
  // and we will use use cases based on our need.

  /// It is shit code
  @Bindable private var gifViewModel = DynamicMediaViewModel(service: GifServiceUseCase())
  @Bindable private var clipViewModel = DynamicMediaViewModel(service: ClipsServiceUseCase())
  @Bindable private var stickerViewModel = DynamicMediaViewModel(service: StickersServiceUseCase())
  
  @Environment(\.dismiss) private var dismiss
  
  private let calculator = MasonryLayoutCalculator()
  
  @State private var selectedType: MediaType = .gifs
  @State private var rows: [RowLayout] = []
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        searchBar
        
        Group {
          switch selectedType {
          case .gifs:
            mediaContent(viewModel: gifViewModel)
          case .clips:
            mediaContent(viewModel: clipViewModel)
          case .stickers:
            mediaContent(viewModel: stickerViewModel)
          }
        }

        
        mediaTypeSelector
      }
      .navigationTitle(selectedType.displayName)
      .navigationBarTitleDisplayMode(.inline)
    }
    .task {
      await loadInitialContent()
    }
    .onChange(of: selectedType) {
      Task {
        await loadInitialContent()
      }
    }
  }
  
  private func mediaContent<T: MediaServiceUseCase>(viewModel: DynamicMediaViewModel<T>) -> some View {
    MasonryGridView(rows: rows) {
      Task {
        await viewModel.loadNextPageIfNeeded()
      }
    }
    .frame(maxWidth: .infinity)
    .onChange(of: viewModel.items) { _ in
      rows = calculator.createRows(from: viewModel.items)
    }
  }
  
  private func loadInitialContent() async {
    switch selectedType {
    case .gifs:
      await gifViewModel.loadTrendingItems()
    case .clips:
      await clipViewModel.loadTrendingItems()
    case .stickers:
      await stickerViewModel.loadTrendingItems()
    }
  }
  
  private var mediaTypeSelector: some View {
    ZStack {
      Color(red: 24/255, green: 28/255, blue: 31/255)
        .ignoresSafeArea()
      
      HStack(spacing: 20) {
        mediaTypeButton("GIFs", type: .gifs)
        mediaTypeButton("Clips", type: .clips)
        mediaTypeButton("Stickers", type: .stickers)
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 44)
  }

  private func mediaTypeButton(_ title: String, type: MediaType) -> some View {
      Button(action: {
          withAnimation {
              selectedType = type
          }
      }) {
          Text(title)
              .font(.system(size: 17))
              .foregroundColor(selectedType == type ? .white : Color.white.opacity(0.5))
              .padding(.vertical, 12)
              .padding(.horizontal, 16)
              .background(
                  selectedType == type ?
                  Capsule()
                      .fill(Color(red: 52/255, green: 120/255, blue: 246/255))
                  : nil
              )
      }
  }
  
  private var searchBar: some View {
    HStack(spacing: 8) {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.gray)
        TextField("Search GIFs", text: .constant(""))
          .font(.system(size: 16))
      }
      .padding(8)
      .background(Color(.systemGray6))
      .cornerRadius(8)
    }
    .padding(.horizontal)
    .padding(.vertical, 8)
    .background(Color.white)
  }
}
