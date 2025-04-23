# Components Module

The Components module provides reusable UI elements and controls used throughout the KlipyiOS-demo app, with a focus on chat and media functionality. These components are designed to be configurable, reusable, and follow SwiftUI best practices.

## Component Groups

### ChatMessage

Display components for individual chat messages with support for text, images, and videos.

```swift
struct ChatMessageView: View {
  // Displays messages with different styling based on sender
}
```

**Features:**
- Configurable message styling and layout
- Text message rendering with proper formatting
- Image content display with appropriate scaling
- Video content with playback controls
- Sender-based styling (left/right alignment)

**Files:**
- `ChatMessageConfiguration.swift` - Configuration options for message appearance
- `ChatMessageView.swift` - Main message component
- `ImageContentView.swift` - Image content renderer
- `VideoContentView.swift` - Video content renderer with playback controls

### ChatPreview

Components for displaying chat conversation previews in lists or grids.

```swift
struct ChatPreview: View {
  // Displays preview of a chat conversation
}
```

**Features:**
- User avatar with online status indicator
- Message preview with truncation
- Timestamp formatting
- Unread message counter
- Configurable theming

**Files:**
- `AvatarView.swift` - User avatar component with customization
- `ChatInfoView.swift` - Information display for chats
- `ChatPreview.swift` - Main preview component
- `ChatPreviewModel.swift` - Data model for preview content
- `ChatPreviewTheme.swift` - Theme configuration
- `OnlineStatusIndicator.swift` - Online status indicator
- `UnreadCountBadge.swift` - Unread message counter badge

### CustomMenu

Contextual menu system with animations and nested menu support.

```swift
struct CustomMenu: View {
  // Displays custom menu with animations
}
```

**Features:**
- Animated menu transitions
- Multi-level menu support
- Report functionality
- Customizable appearance
- Action handling through closures

**Files:**
- `BackButton.swift` - Navigation back button
- `CustomMenu.swift` - Main menu component
- `MainMenuView.swift` - Primary menu view
- `Menu+Models.swift` - Data models for menu structure
- `MenuButton.swift` - Individual menu button component
- `MenuConfiguration.swift` - Menu appearance configuration
- `ReportMenuView.swift` - Specialized menu for content reporting

### MediaSearchBar

Search and filtering interface for media content.

```swift
struct MediaSearchBar: View {
  // Media search interface with category filtering
}
```

**Features:**
- Search field with clear functionality
- Category filtering with horizontal scrolling
- Responsive layout
- Visual feedback for selection states

**Files:**
- `CategoryIconButton.swift` - Category selection button
- `MediaCategory.swift` - Category data model
- `MediaSearchBar.swift` - Main search bar component
- `MediaSearchConfiguration.swift` - Configuration for search appearance

### MessageInput

Message composition interface for chat screens.

```swift
struct MessageInputView: View {
  // Text input with send and media attachment buttons
}
```

**Features:**
- Text input field with auto-expansion
- Send button with activation state
- Media picker button
- Keyboard integration
- Haptic feedback

**Files:**
- `MessageInputConfiguration.swift` - Configuration for input appearance
- `MessageInputView.swift` - Main input component

### WebView

Web content display within the app interface.

```swift
struct KlipyWebView: View {
  // Web content viewer with navigation controls
}
```

**Features:**
- URL and HTML content loading
- Navigation handling
- External link management
- SwiftUI/UIKit bridging

**Files:**
- `KlipyWebView.swift` - Main web view component
- `KlipyWebViewRepresentable.swift` - UIKit web view wrapper for SwiftUI

## Usage

Components are designed to be modular and reusable across the app. Import them as needed:

```swift
import SwiftUI

struct MyView: View {
  var body: some View {
    VStack {
      // Use a chat preview component
      ChatPreview(model: chatModel, theme: .default)
      
      // Use a message input component
      MessageInputView(
        messageText: $messageText,
        isFocused: _isFocused,
        onSendMessage: handleSendMessage,
        onMediaPickerTap: showMediaPicker
      )
    }
  }
}
```

## Design Principles

These components follow several key design principles:

1. **Configurability** - Most components accept configuration parameters
2. **Composition** - Components are composed of smaller, focused subcomponents
3. **Closure-based callbacks** - Interaction is handled through closure callbacks
4. **Theme awareness** - Support for consistent theming across the app
5. **Accessibility** - Components consider accessibility needs where appropriate