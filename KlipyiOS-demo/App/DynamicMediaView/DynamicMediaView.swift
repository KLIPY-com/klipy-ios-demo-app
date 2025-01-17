//
//  GifGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

struct DynamicMediaView: View {
  @Bindable private var viewModel = DynamicMediaViewModel()
  
  @State private var searchText = ""
  @State private var rows: [RowLayout] = []
  
  @Environment(\.dismiss) private var dismiss
  private let calculator = MasonryLayoutCalculator()
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        searchBar
        
        mediaContent
        
        mediaTypeSelector
      }
      .navigationTitle(viewModel.currentType.displayName)
      .navigationBarTitleDisplayMode(.inline)
    }
    .task {
      await viewModel.loadTrendingItems()
    }
    .onChange(of: searchText) { _, newValue in
      Task {
        await viewModel.searchItems(query: newValue)
      }
    }
  }
  
  private var mediaContent: some View {
    ZStack {
      MasonryGridView(rows: rows) {
        Task {
          await viewModel.loadNextPageIfNeeded()
        }
      }
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
  DynamicMediaView()
}
