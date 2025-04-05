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
  var _items: [MediaDomainModel] = []
  var items: [MediaDomainModel] {
    get {
      return _items
    }
    
    set {
      _items = newValue
    }
  }

  @ObservationIgnored
  private(set) var isLoading = false
  
  private(set) var hasError = false
  private(set) var errorMessage: String?
  private(set) var hasMorePages = true
  private(set) var searchQuery = ""
  private(set) var currentType: MediaType
  
  private(set) var mediaAvailability: MediaContent?
  private let healthCheckService = HealthCheckServiceUseCase()

  

  public var activeCategory: MediaCategory?

  var shouldDismiss: Bool = false
  var categorySearchText = ""
  var categories: [MediaCategory] = []
  
  @ObservationIgnored
  private var currentPage = 1
  
  @ObservationIgnored
  private let perPage = 24
  
  @ObservationIgnored
  private var service: MediaService
  
  @ObservationIgnored
  var gridMeta: GridMeta
  
  init(initialType: MediaType = .gifs) {
    self.currentType = initialType
    self.service = .create(for: initialType)
    self.gridMeta = .init(itemMinWidth: 0, adMaxResizePercent: 0)
  }
  
  @MainActor
  func checkServicesHealth() async {
    do {
      let healthStatus = try await healthCheckService.fetchUpdateInfo()
      self.mediaAvailability = healthStatus
      
      if !isCurrentTypeAvailable {
        switchToFirstAvailableType()
      }
    } catch {
      print("Health check failed: \(error)")
    }
  }
  
  private var isCurrentTypeAvailable: Bool {
    guard let availability = mediaAvailability else { return true }
    
    switch currentType {
    case .gifs: return availability.gifs.isAlive
    case .clips: return availability.clips.isAlive
    case .stickers: return availability.stickers.isAlive
    case .ad: return true
    }
  }
  
  @MainActor
  private func switchToFirstAvailableType() {
    guard let availability = mediaAvailability else { return }
    
    if availability.clips.isAlive {
      switchToType(.clips)
    } else if availability.stickers.isAlive {
      switchToType(.stickers)
    } else if availability.gifs.isAlive {
      switchToType(.gifs)
    } else {
      shouldDismiss = true
    }
  }
  
  func switchToType(_ type: MediaType) {
    guard type != currentType else { return }
    
    resetState()
    currentType = type
    service = .create(for: type)
  }
  
  func resetState() {
    currentPage = 1
    hasMorePages = true
    searchQuery = ""
    categorySearchText = ""
    isLoading = false
    hasError = false
    errorMessage = nil
    items = []
    hasCompletedInitialLoad = false
  }
  
  private(set) var hasCompletedInitialLoad = false
  
  @MainActor
  func initialLoad() async {
    resetState()
    do {
      activeCategory = categories.first { $0.type == .trending }
      
      let trendingResults = try await service.fetchTrending(page: 1, perPage: perPage)
      gridMeta = trendingResults.gridMeta
      items = trendingResults.items
      hasMorePages = trendingResults.hasNext
      
      let recentsResult = try await service.fetchRecents(page: 1, perPage: perPage)
      
      currentPage = 2
      isLoading = false
    } catch {
      hasError = true
      errorMessage = error.localizedDescription
      isLoading = false
    }
  }
  
  func loadRecentItems() async {
    guard !isLoading && hasMorePages else { return }
    
    isLoading = true
    hasError = false
    errorMessage = nil
    
    do {
      let recentItems = try await service.fetchRecents(
        page: currentPage,
        perPage: perPage
      )
      
      gridMeta = recentItems.gridMeta
      
      await MainActor.run {
        if currentPage == 1 {
          items = recentItems.items
        } else {
          items.append(contentsOf: recentItems.items)
        }
        
        hasMorePages = recentItems.hasNext
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
  
  func baseLoadRecentItems(page: Int = 1) async throws -> [MediaDomainModel] {
      isLoading = true
      hasError = false
      errorMessage = nil
      
      do {
        let domainItems = try await service.fetchRecents(
          page: page,
          perPage: perPage
        )
        
        await MainActor.run {
          isLoading = false
        }
        
        return domainItems.items
      } catch {
        await MainActor.run {
          hasError = true
          errorMessage = error.localizedDescription
          isLoading = false
        }
        throw error
      }
    }
  
  func baseLoadTrendingItems(page: Int = 1) async throws -> [MediaDomainModel] {
      isLoading = true
      hasError = false
      errorMessage = nil
      
      do {
        let domainItems = try await service.fetchTrending(
          page: page,
          perPage: perPage
        )
        
        await MainActor.run {
          isLoading = false
        }
        
        return domainItems.items
      } catch {
        await MainActor.run {
          hasError = true
          errorMessage = error.localizedDescription
          isLoading = false
        }
        throw error
      }
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
      
      gridMeta = domainItems.gridMeta
      
      await MainActor.run {
        if currentPage == 1 {
          items = domainItems.items
        } else {
          items.append(contentsOf: domainItems.items)
        }
        
        hasMorePages = domainItems.hasNext
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
  
  @MainActor
  func searchItems(query: String) async {
    if searchQuery != query {
      searchQuery = query
      items = []
      currentPage = 1
      hasMorePages = true
    }
    
    guard !query.isEmpty else {
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
      
      gridMeta = domainItems.gridMeta
      
      if currentPage == 1 {
        items = domainItems.items
      } else {
        items.append(contentsOf: domainItems.items)
      }

      hasMorePages = domainItems.hasNext
      currentPage += 1
      isLoading = false
    } catch {
      await MainActor.run {
        hasError = true
        errorMessage = error.localizedDescription
        isLoading = false
      }
    }
  }
  
  @MainActor
  func loadNextPageIfNeeded() async {
    guard !isLoading && hasMorePages else { return }
    
    if searchQuery.isEmpty && categorySearchText.isEmpty {
      switch activeCategory?.type {
      case .trending:
       await loadTrendingItems()
      case .recents:
       await loadRecentItems()
      case nil:
        return
      case .some(.none):
        return
      }
    } else {
      await searchItems(query: searchQuery.isEmpty ? categorySearchText : searchQuery)
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

extension DynamicMediaViewModel {
  func getMediaItem(by id: Int64) -> MediaDomainModel? {
    return items.first { $0.id == Int(id) }
  }
  
  func getMediaItemBySlug(by slug: String) -> MediaDomainModel? {
    return items.first { $0.slug == slug }
  }
  
  @MainActor
  func fetchCategories() async {
    do {
      let categoriesResponse = try await service.categories()
      
      let predefinedCategories = [
        MediaCategory(name: "trending", type: .trending),
        MediaCategory(name: "recent", type: .recents)
      ]
      
      let mappedCategories = predefinedCategories + categoriesResponse.data.map {
        MediaCategory(name: $0)
      }

      self.categories = mappedCategories
    } catch {
      print("Error fetching categories: \(error)")
    }
  }
}
