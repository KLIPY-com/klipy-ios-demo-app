//
//  DynamicMediaViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation
import SwiftUI

@Observable
class DynamicMediaViewModel {
  private(set) var gifs: [GifItem] = []

  private(set) var isLoading = false
  private(set) var hasError = false
  private(set) var errorMessage: String?
  private(set) var hasMorePages = true
  private(set) var searchQuery = ""
  
  private var currentPage = 1
  private let perPage = 24
  private let gifService = GifServiceUseCase()

  func loadTrendingGifs() async {
    guard !isLoading && hasMorePages else { return }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let response = try await gifService.fetchTrending(
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          gifs = response.data.data
        } else {
          gifs.append(contentsOf: response.data.data)
        }
        
        hasMorePages = response.data.hasNext
        currentPage += 1
        isLoading = false
      }
    } catch {
      await MainActor.run {
        hasError = true
        errorMessage = error.localizedDescription
        isLoading = false
      }
    }
  }

  func searchGifs(query: String) async {
    guard !query.isEmpty else {
      /// Reset to trending if search is cleared
      currentPage = 1
      await loadTrendingGifs()
      return
    }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let response = try await gifService.searchGifs(
        query: query,
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          gifs = response.data.data
        } else {
          gifs.append(contentsOf: response.data.data)
        }
        
        hasMorePages = response.data.hasNext
        currentPage += 1
        isLoading = false
      }
    } catch {
      await MainActor.run {
        hasError = true
        errorMessage = error.localizedDescription
        isLoading = false
      }
    }
  }
  
  /// Load next page (used for infinite scrolling)
  func loadNextPageIfNeeded() async {
    guard !isLoading && hasMorePages else { return }
    
    if searchQuery.isEmpty {
      await loadTrendingGifs()
    } else {
      await searchGifs(query: searchQuery)
    }
  }
  

  func refresh() async {
    currentPage = 1
    hasMorePages = true
    
    if searchQuery.isEmpty {
      await loadTrendingGifs()
    } else {
      await searchGifs(query: searchQuery)
    }
  }

  func updateSearchQuery(_ query: String) {
    searchQuery = query
    currentPage = 1
    hasMorePages = true
    Task {
      await searchGifs(query: query)
    }
  }
  
  // Retry after error
  func retry() async {
    if searchQuery.isEmpty {
      await loadTrendingGifs()
    } else {
      await searchGifs(query: searchQuery)
    }
  }
}

// MARK: - Pagination Helper
extension DynamicMediaViewModel {
  func shouldLoadMore(currentItem: GifItem) -> Bool {
    guard let itemIndex = gifs.firstIndex(where: { $0.id == currentItem.id }) else {
      return false
    }
    
    return itemIndex >= gifs.count - 5
  }
}

// MARK: - Error Handling Helper
extension DynamicMediaViewModel {
  var errorDisplayMessage: String {
    errorMessage ?? "An unknown error occurred. Please try again."
  }
}
