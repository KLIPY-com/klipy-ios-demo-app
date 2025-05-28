# Klipy GIF API iOS Demo Application

<img src="https://github.com/user-attachments/assets/9b687d60-f96e-4702-908c-eb797e794697" alt="Klipy iOS Demo Screenshot" width="350" height="350">

iOS Demo application showcasing Klipy's media display capabilities, featuring a perfect masonry grid layout for GIFs, stickers, and video clips.

## Overview

App demonstrates how to implement a responsive, performant media grid using the MasonryLayoutCalculator for optimal display of media content. The app provides examples of

- Masonry-style grid layouts with perfect content fitting
- Media content display (GIFs, stickers, video clips)
- Dynamic ad integration
- Networking and API consumption
- SwiftUI components and architecture patterns

## Table of Contents

- [Architecture](#architecture)
- [Core Modules](#core-modules)
- [Perfect Grid Layout System](#perfect-grid-layout-system)
- [Ad Integration](#ad-integration)
- [Media Content Display](#media-content-display)
- [Getting Started](#getting-started)
- [Documentation](#documentation)

## Architecture

The application follows a modern SwiftUI-based architecture with:

- **MVVM** (Model-View-ViewModel) pattern for UI components
- **MVVM** Observation framework
- **Use Case** pattern for business logic
- **Service** layer for API communication
- **Repository** pattern for data abstraction

## Core Modules

### [ChatFeature Module](./KlipyiOS-demo/App/ChatFeature/README.md)

The ChatFeature module implements a chat interface with media sharing capabilities, demonstrating the integration of the masonry grid within a messaging context.

### [Components Module](./KlipyiOS-demo/App/Components/README.md)

Reusable UI elements and controls used throughout the app, with a focus on chat and media functionality.

### [DynamicMediaView Module](./KlipyiOS-demo/App/DynamicMediaView/README.md)

A comprehensive media browsing and selection interface that enables users to browse, search, and interact with various types of media content (GIFs, clips, stickers).

### [Infrastructure Module](./KlipyiOS-demo/Infrastructure/README.md)

The data and networking layer for the app, providing structured access to the Klipy API for media content like GIFs, clips, and stickers.

### [Networking Module](./KlipyiOS-demo/Networking/README.md)

A robust, type-safe networking layer built on top of Moya and Alamofire, handling API requests, response parsing, error handling, and providing modern Swift async/await support.

## Perfect Grid Layout System

The core feature of this demo is the MasonryLayoutCalculator, which creates a visually pleasing, perfectly-fitted grid layout for media content.

### MasonryLayoutCalculator

The `MasonryLayoutCalculator` is responsible for calculating optimal layouts for media items in a grid, ensuring that items maintain their aspect ratios while fitting perfectly within rows.

#### How It Works

1. **Input**: Takes a list of media items with their original dimensions and a container width
2. **Processing**:
   - Groups items into rows
   - Calculates optimal height for each row
   - Adjusts item widths proportionally to maintain aspect ratios
   - Handles special cases for ads
   - Assigns x/y positions to each item
3. **Output**: Returns rows with perfectly positioned items

#### Key Features

- Maintains original aspect ratios of media items
- Dynamically adjusts row heights for optimal visual balance
- Special handling for ad content
- Efficient layout calculation even with large numbers of items
- Smart distribution of leftover space

#### Usage Example

```swift
// Create a layout calculator with default parameters
let calculator = MasonryLayoutCalculator(
    containerWidth: UIScreen.main.bounds.width,
    horizontalSpacing: 1,
    minRowHeight: 50,
    maxRowHeight: 180,
    maxItemsPerRow: 4
)

// Define layout metadata
let meta = GridMeta(
    itemMinWidth: 50,
    adMaxResizePercent: 20
)

// Calculate layout for media items
let rows = calculator.createRows(from: mediaItems, withMeta: meta)

// Use the calculated layout in a SwiftUI view
MasonryGridView(
    rows: rows,
    hasNext: hasMoreContent,
    onLoadMore: loadMoreContent,
    previewLoaded: handlePreviewLoaded,
    onSend: handleItemSelected,
    previewItem: $previewItem
)
```

### Key Components

#### GridItemLayout

Represents a single media item in the grid with properties for dimensions, position, and content URLs:

```swift
struct GridItemLayout: Identifiable {
    let id: Int64
    let url: String
    let highQualityUrl: String
    let mp4Media: MediaFile?
    let previewUrl: String
    var width: CGFloat
    var height: CGFloat
    var xPosition: CGFloat
    var yPosition: CGFloat
    let originalWidth: CGFloat
    let originalHeight: CGFloat
    var newWidth: CGFloat
    let type: String
    let title: String
    let slug: String
}
```

#### RowLayout

Groups related `GridItemLayout` objects into a row with a consistent height:

```swift
struct RowLayout {
    var items: [GridItemLayout]
    var height: CGFloat
}
```

#### MasonryGridView

Renders the calculated layout using SwiftUI, supporting interactions like scrolling, tapping, and previewing:

```swift
struct MasonryGridView: View {
    let rows: [RowLayout]
    let hasNext: Bool
    let onLoadMore: () -> Void
    let previewLoaded: (GridItemLayout) -> Void
    let onSend: (GridItemLayout) -> Void
    @Binding var previewItem: GlobalMediaItem?
    // Implementation details...
}
```

## Ad Integration

The demo showcases seamless ad integration within the masonry grid.

### Ad Handling in MasonryLayoutCalculator

The calculator includes special logic for ad positioning and sizing:

1. **Ad Placement**: Ads are typically positioned in the first two slots of a row
2. **Ad Sizing**: Special rules prevent ads from being overly distorted
3. **Row Configuration**: When ads appear after the first two positions, rows are reconfigured

### Ad Parameters

The `AdParameters` struct provides consistent ad targeting parameters:

```swift
struct AdParameters {
    static let shared = AdParameters()
    
    var parameters: [String: Any] {
        // Device info, ad dimensions, and targeting parameters
    }
}
```

Use the extension method to add ad parameters to your API requests:

```swift
let apiParams = ["query": "cat"].withAdParameters()
```

### WebView for Ad Rendering

The app uses a custom WebView implementation (`KlipyWebView` and `KlipyWebViewRepresentable`) specifically designed for rendering ads within the UI:

- Secure ad rendering isolated from app content
- Custom navigation handling for ad interactions  
- SwiftUI integration via UIViewRepresentable

### withAdParameters Extension

The `withAdParameters()` extension method simplifies adding standardized ad parameters to API requests:

```swift
// Inside Dictionary extension
func withAdParameters() -> [String: Any] {
  self.merging(AdParameters.shared.parameters) { current, _ in current }
}
```

This extension ensures consistent ad targeting parameters are included with requests, such as:
- Device information (OS, model, screen dimensions)
- Ad size constraints
- Device identifiers for ad targeting
- User language preferences

We use UserAgentManager to get correct user agent and then we use it inside headers

```swift
var headers: [String: String]? {
    ["User-Agent": UserAgentManager.shared.userAgent]
}
```

For  configuring Ad parameters, you can check `AdParameters.swift` file

```swift
struct AdParameters {
  static let shared = AdParameters()
  
  var parameters: [String: Any] {
    var params: [String: Any] = [:]
    
    // Device Info
    params["ad-os"] = "ios"
    params["ad-osv"] = UIDevice.current.systemVersion
    params["ad-make"] = "apple"
    params["ad-model"] = "iphone"
    params["ad-device-w"] = UIScreen.main.bounds.width
    params["ad-device-h"] = UIScreen.main.bounds.height
    params["ad-pxratio"] = UIScreen.main.scale
    
    // Ad dimensions
    params["ad-min-width"] = 50
    params["ad-max-width"] = UIScreen.main.bounds.width - 20
    params["ad-min-height"] = 50
    params["ad-max-height"] = 200
    
    let identifierForAdvertising = ASIdentifierManager.shared().advertisingIdentifier
    params["ad-ifa"] = identifierForAdvertising.uuidString
    params["ad-language"] = "EN"
    
    return params
  }
}

extension Dictionary where Key == String, Value == Any {
  func withAdParameters() -> [String: Any] {
    self.merging(AdParameters.shared.parameters) { current, _ in current }
  }
}
```

## Media Content Display

The demo shows how to efficiently display different types of media:

### GIFs and Stickers

Rendered using `SDWebImageSwiftUI` for optimal performance:

```swift
AnimatedImage(url: URL(string: item.url), isAnimating: .constant(true))
    .resizable()
    .playbackRate(1.0)
    .playbackMode(.bounce)
```

### Video Clips

Displayed with title overlay and playback controls:

```swift
if item.type == "clip" {
    // Clip title and controls overlay
}
```

### Media Loading and Caching

The app demonstrates proper techniques for efficient media loading:

- Lazy loading through `LazyGIFView`
- Image caching via SDWebImage
- Low-quality previews during loading (blur hash or base64 previews)

## Getting Started

1. Clone the repository
2. Open `KlipyiOS-demo.xcodeproj` in Xcode
3. Install dependencies using Swift Package Manager (automatically handled by Xcode)
4. Build and run on a simulator or device
