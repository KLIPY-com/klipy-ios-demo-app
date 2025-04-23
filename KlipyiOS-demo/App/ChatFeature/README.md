# ChatFeature Module

The ChatFeature module implements a comprehensive chat interface with media sharing capabilities for the KlipyiOS-demo app.

## Overview

This module provides a complete chat experience with text messaging, rich media content support, animations, and an interactive UI. It follows the MVVM architecture pattern with SwiftUI.

## Components

### ChatFeatureViewModel

The view model that manages chat state and business logic:
- Handles text and media message sending
- Manages video player instances
- Simulates chat responses with randomized replies
- Controls media picker visibility

```swift
@Observable
final class ChatFeatureViewModel {
  // Manages chat state and interactions
}
```

### ChatView

The main chat interface that provides the overall chat experience:
- Custom navigation with user information
- Message display with automatic scrolling
- Media sharing and preview functionality
- Gesture-based keyboard dismissal

```swift
struct ChatView: View {
  // Primary chat interface
}
```

### ContentPushingMediaPickerModifier

A custom view modifier that presents the media picker with content-pushing animation:
- Adjustable sheet height (half/full screen)
- Gesture-based dragging and dismissal
- Keyboard height adaptation

```swift
struct ContentPushingMediaPickerModifier: ViewModifier {
  // Handles media picker presentation
}
```

### MessagesListView

Displays chat messages in a scrollable list with animations:
- Lazy loading for performance
- Custom transitions for message insertion
- Proper message identification for animations

```swift
struct MessagesListView: View {
  // Message list display
}
```

### AnimationCoordinator

Provides consistent animation patterns across the module:
- Defines animation presets for natural feel
- Manages complex multi-stage animations
- Coordinates timing for sheet animations

```swift
class AnimationCoordinator: ObservableObject {
  // Coordinates animation sequences
}
```

### ScrollOverlayView

Shows visual feedback during scrolling interactions:
- Keyboard dismiss indicator
- Dynamic opacity based on gesture distance

```swift
struct ScrollOverlayView: View {
  // Visual feedback during scrolling
}
```

## Usage

The ChatFeature module is typically accessed through the main app navigation, presenting a complete chat interface when a conversation is selected.

```swift
// Example of presenting the chat view
ChatView(viewModel: ChatFeatureViewModel(chatPreviewModel: selectedChat))
```

## Key Features

- Real-time message interactions
- Rich media support (GIFs, videos, images)
- Animated transitions and feedback
- Gesture-based interactions
- Media sharing with analytics tracking
- Content reporting functionality