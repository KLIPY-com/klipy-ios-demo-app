//
//  PreviewViewModel 2.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 17.01.25.
//

import SwiftUI

class PreviewViewModel: ObservableObject {
  @Published var selectedItem: GlobalMediaItem?
  @Published var isDragging = false
  @Published var dragOffset: CGSize = .zero
  @Published var dragScale: CGFloat = 1.0
  @Published var pressScale: CGFloat = 1.0
  @Published var isShowingReportMenu = false
}
