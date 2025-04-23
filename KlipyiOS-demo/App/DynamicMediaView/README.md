# DynamicMediaView Module

The DynamicMediaView module provides a comprehensive media browsing and selection interface for the KlipyiOS-demo app. It enables users to browse, search, and interact with various types of media content (GIFs, clips, stickers) from the Klipy platform.

## Key Components

### DynamicMediaView

The main view component that presents the media browsing interface.

```swift
struct DynamicMediaView: View {
  // Main interface for media browsing and selection
}
```

**Features:**
- Media type switching (GIFs, clips, stickers)
- Search functionality with debounced input
- Category filtering (trending, recent, custom categories)
- Infinite scrolling with pagination
- Media preview and selection
- Analytics tracking for views and shares
- Health check integration for service availability

### DynamicMediaViewModel

The view model that manages the state and business logic for media browsing.

```swift
@Observable
class DynamicMediaViewModel {
  // Manages media state and API interactions
}
```

**Responsibilities:**
- Media content loading and caching
- Pagination handling
- Search and filtering
- Category management
- Service health monitoring
- Media type switching
- Analytics tracking (views, shares, reports)
- Error handling and loading state management

### MediaService

A facade that unifies different media service types under a common interface.

```swift
enum MediaService {
  case gif(GifServiceUseCase)
  case clip(ClipsServiceUseCase)
  case sticker(StickersServiceUseCase)
  case none
  
  // Common methods across all service types
}
```

**Features:**
- Unified API for different media types
- Type-specific service selection
- Factory method for service creation
- Consistent error handling
- Domain model conversion

### SearchDebouncer

An actor that provides debounced search functionality to prevent excessive API calls.

```swift
actor SearchDebouncer {
  // Prevents rapid-fire API calls during typing
}
```

**Features:**
- Task-based debouncing
- Configurable debounce duration
- Task cancellation for superseded requests
- Async/await support
- Thread safety through actor isolation

## Data Flow

1. User interacts with `DynamicMediaView` (search, category selection, scrolling)
2. `DynamicMediaViewModel` processes user interactions and manages state
3. `MediaService` provides a uniform interface to fetch content from different service types
4. `SearchDebouncer` ensures search queries are efficiently processed
5. API results are transformed into domain models and displayed in a masonry grid layout
6. Analytics events are tracked for user interactions (views, shares, reports)

## Usage

The DynamicMediaView is typically presented as a sheet or overlay when selecting media:

```swift
DynamicMediaView(
  onSend: { mediaItem in
    // Handle the selected media item
  },
  previewItem: $previewItem,
  sheetHeight: $sheetHeight
)
```

## Integration Points

- **ChatFeature**: Used within the chat interface for media selection
- **MasonryLayout**: Displays media items in a visually appealing grid
- **MediaSearchBar**: Provides search and category filtering capabilities
- **Infrastructure**: Uses the service layer to fetch media content
- **Networking**: Communicates with the Klipy API

## Error Handling

The module implements robust error handling:
- Service health checks to detect and adapt to API availability
- Error state display with appropriate user feedback
- Automatic type switching when a service becomes unavailable
- Debounced input to prevent excessive failed requests

## Performance Considerations

- Efficient grid layout calculation with `MasonryLayoutCalculator`
- Lazy loading of images with pagination
- Debounced search to reduce API calls
- Background task execution for API communication
- Animation optimization for smooth transitions