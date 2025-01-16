//
//  DynamicMediaViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 15.01.25.
//

import Foundation
import SwiftUI

@Observable
class DynamicMediaViewModel<Service: MediaServiceUseCase> where Service.Item: MediaItem {
  private(set) var items: [Service.Item] = []
  private(set) var isLoading = false
  private(set) var hasError = false
  private(set) var errorMessage: String?
  private(set) var hasMorePages = true
  private(set) var searchQuery = ""
  
  @ObservationIgnored
  private var currentPage = 1
  
  @ObservationIgnored
  private let perPage = 24
  
  @ObservationIgnored
  private let service: Service
  
  init(service: Service) {
    self.service = service
  }
  
  func loadTrendingItems() async {
    guard !isLoading && hasMorePages else { return }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let response = try await service.fetchTrendingItems(
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          items = response.data.data
        } else {
          items.append(contentsOf: response.data.data)
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
  
  func searchItems(query: String) async {
    guard !query.isEmpty else {
      currentPage = 1
      await loadTrendingItems()
      return
    }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let response = try await service.searchItems(
        query: query,
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          items = response.data.data
        } else {
          items.append(contentsOf: response.data.data)
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
  
  // Rest of the methods remain the same but use 'items' instead of 'gifs'
  func loadNextPageIfNeeded() async {
    guard !isLoading && hasMorePages else { return }
    
    if searchQuery.isEmpty {
      await loadTrendingItems()
    } else {
      await searchItems(query: searchQuery)
    }
  }
  
  func shouldLoadMore(currentItem: Service.Item) -> Bool {
    guard let itemIndex = items.firstIndex(where: { $0.id == currentItem.id }) else {
      return false
    }
    return itemIndex >= items.count - 5
  }
}
