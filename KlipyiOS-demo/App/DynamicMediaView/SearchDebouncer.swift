actor SearchDebouncer {
  private var task: Task<Void, Never>?
  
  func debounce(
    for duration: Duration = .milliseconds(300),
    action: @escaping @Sendable @MainActor () async -> Void
  ) {
    // Cancel any previously scheduled debounce task.
    task?.cancel()
    
    // Schedule a new task.
    task = Task { [weak self] in
      // Pause for the debounce duration. If cancelled during sleep, ignore the error.
      try? await Task.sleep(for: duration)
      
      // Check for cancellation one more time before proceeding.
      guard !Task.isCancelled else { return }
      
      // Execute the action on the MainActor.
      await MainActor.run {
        await action()
      }
      
      // Clear the reference to the completed task in an actor-safe way.
      await self?.clearTask()
    }
  }
  
  // This helper method resets the stored task. Since it's an actor method,
  // it safely updates the actor's state.
  private func clearTask() {
    task = nil
  }
}