//
//  GifGridView.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import SwiftUI

struct DynamicMediaView: View {
  @Bindable var model = DynamicMediaViewModel()
  @Environment(\.dismiss) private var dismiss
  
  private let calculator = MasonryLayoutCalculator()
  @State private var rows: [RowLayout] = []
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        searchBar
        
        MasonryGridView(rows: rows) {
          Task {
            await model.loadNextPageIfNeeded()
          }
        }
        .frame(maxWidth: .infinity)

        .onChange(of: model.gifs) { _ in
          rows = calculator.createRows(from: model.gifs)
        }
      }
      .navigationTitle("GIFs")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
    }
    .task {
      await model.loadTrendingGifs()
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
