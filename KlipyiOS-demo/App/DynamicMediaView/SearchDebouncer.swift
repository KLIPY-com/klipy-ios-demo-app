//
//  SearchDebouncer.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.02.25.
//

import Foundation

actor SearchDebouncer {
  private var task: Task<Void, Never>?
  
  func debounce(
    for duration: Duration = .milliseconds(300),
    action: @escaping @Sendable @MainActor () async -> Void
  ) {
    task?.cancel()
    
    /// Schedule a new task.
    task = Task { [weak self] in
      try? await Task.sleep(for: duration)
      
      guard !Task.isCancelled else { return }
      await action()
      
      await self?.clearTask()
    }
  }
  
  private func clearTask() {
    task = nil
  }
}
