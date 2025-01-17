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
  private(set) var items: [MediaDomainModel] = []
  private(set) var isLoading = false
  private(set) var hasError = false
  private(set) var errorMessage: String?
  private(set) var hasMorePages = true
  private(set) var searchQuery = ""
  private(set) var currentType: MediaType
  
  @ObservationIgnored
  private var currentPage = 1
  
  @ObservationIgnored
  private let perPage = 24
  
  @ObservationIgnored
  private var service: MediaService
  
  init(initialType: MediaType = .gifs) {
    self.currentType = initialType
    self.service = .create(for: initialType)
  }
  
  func switchToType(_ type: MediaType) {
    guard type != currentType else { return }
    
    /// Reset state
    items = []
    currentPage = 1
    hasMorePages = true
    searchQuery = ""
    isLoading = false
    hasError = false
    errorMessage = nil
    
    /// Switch Service Type
    currentType = type
    service = .create(for: type)
  }
  
  func loadTrendingItems() async {
    guard !isLoading && hasMorePages else { return }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let domainItems = try await service.fetchTrending(
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          items = domainItems
        } else {
          items.append(contentsOf: domainItems)
        }
        hasMorePages = !domainItems.isEmpty
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
    if searchQuery != query {
      searchQuery = query
      items = []
      currentPage = 1
      hasMorePages = true
    }
    
    guard !query.isEmpty else {
      await loadTrendingItems()
      return
    }
    
    guard !isLoading && hasMorePages else { return }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let domainItems = try await service.search(
        query: query,
        page: currentPage,
        perPage: perPage
      )
      
      await MainActor.run {
        if currentPage == 1 {
          items = domainItems
        } else {
          items.append(contentsOf: domainItems)
        }
        hasMorePages = !domainItems.isEmpty
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
  
  func loadNextPageIfNeeded() async {
    guard !isLoading && hasMorePages else { return }
    
    if searchQuery.isEmpty {
      await loadTrendingItems()
    } else {
      await searchItems(query: searchQuery)
    }
  }
  
  // Analytics and actions become much simpler
  func trackView(for item: MediaDomainModel) async throws -> FireAndForgetResponse {
    return try await service.trackView(slug: item.slug)
  }
  
  func trackShare(for item: MediaDomainModel) async throws -> FireAndForgetResponse {
    return try await service.trackShare(slug: item.slug)
  }
  
  func hideFromRecent(item: MediaDomainModel) async throws -> FireAndForgetResponse {
    await MainActor.run {
      items.removeAll { $0.id == item.id }
    }
    
    return try await service.hideFromRecent(slug: item.slug)
  }
  
  func reportItem(item: MediaDomainModel, reason: String) async throws -> FireAndForgetResponse {
    return try await service.report(slug: item.slug, reason: reason)
  }
}
