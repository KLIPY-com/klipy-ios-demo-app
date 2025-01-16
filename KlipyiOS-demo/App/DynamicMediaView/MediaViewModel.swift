//
//  MediaViewModel.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

protocol MediaViewModel {
  associatedtype Item
  
  var items: [Item] { get }
  func loadTrendingItems() async
  func loadNextPageIfNeeded() async
  func searchItems(query: String) async
}
