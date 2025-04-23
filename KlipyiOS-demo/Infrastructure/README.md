# Infrastructure Module

The Infrastructure module serves as the data and networking layer for the KlipyiOS-demo app, providing structured access to the Klipy API for media content like GIFs, clips, and stickers. It implements a clean architecture approach with clear separation between models, services, and use cases.

## Directory Structure

```
Infrastructure/
├── Models/
│   ├── AnyResponse/
│   ├── DomainModels/
│   ├── MediaItems/
│   ├── MediaType/
│   ├── Paging/
│   └── ...
├── Services/
├── UseCases/
├── PathComponent.swift
└── UserAgentManager.swift
```

## Key Components

### Models

The models directory contains various data structures representing the application domain:

#### Media Domain Models

```swift
protocol MediaItem: Codable, Equatable {
    var id: String { get }
    var title: String? { get }
    var slug: String { get }
    // Additional properties...
}
```

* `MediaDomainModel` - Core domain model for media content with format variants
* `MediaFile` - Represents a media file with different format options
* `MediaFileVariant` - Contains URL, width, and height for specific formats

#### Media Types

* `GifItem` - Implements `MediaItem` for GIF content
* `ClipItem` - Implements `MediaItem` for video clips
* `StickerItem` - Implements `MediaItem` for stickers

#### Response Wrappers

* `AnyResponse<T>` - Generic wrapper for API responses with pagination data
* `PaginatedData<T>` - Paging information with metadata
* `FireAndForgetResponse` - Simple response for operations without data return

### Services

Services define API endpoints using Moya's `TargetType` pattern:

```swift
enum GifService {
    case trending(page: Int, perPage: Int)
    case search(query: String, page: Int, perPage: Int)
    case categories
    // Additional endpoints...
}
```

Each service implements `KlipyTargetType` and provides:
* URL path components
* HTTP methods
* Request parameters
* Required headers

Available services:
* `GifService` - Endpoints for GIF operations
* `ClipsService` - Endpoints for video clip operations
* `StickersService` - Endpoints for sticker operations
* `HealthCheckService` - Basic API connectivity checking

### Use Cases

Use cases implement business logic and provide a clean interface for the app:

```swift
protocol MediaServiceUseCase {
    func trending(page: Int, perPage: Int) async throws -> PaginatedData<MediaDomainModel>
    func search(query: String, page: Int, perPage: Int) async throws -> PaginatedData<MediaDomainModel>
    // Additional methods...
}
```

Specific implementations:
* `GifServiceUseCase` - GIF-related operations
* `ClipsServiceUseCase` - Video clip operations
* `StickersServiceUseCase` - Sticker operations

These use cases:
* Encapsulate service interactions
* Transform API responses to domain models
* Implement error handling
* Provide async/await interfaces

### Utility Components

* `PathComponent` - Constants for API path components
* `UserAgentManager` - Manages consistent user agent headers

## Architecture Patterns

The Infrastructure module demonstrates several architectural patterns:

1. **Clean Architecture**
   * Separation between data models, domain models, and use cases
   * Unidirectional data flow

2. **Repository Pattern**
   * Services as repositories for specific data types
   * Use cases provide clean access to repositories

3. **Adapter Pattern**
   * API models convert to domain models via `toDomain()` methods
   * UI layer is isolated from API changes

4. **Protocol-Oriented Design**
   * Abstractions via protocols
   * Implementation flexibility and polymorphic behavior

## Usage Examples

### Fetching Trending GIFs

```swift
let gifUseCase = GifServiceUseCase(api: RestApi.liveValue)

Task {
    do {
        let paginatedGifs = try await gifUseCase.trending(page: 1, perPage: 20)
        // Process the returned media models
    } catch {
        // Handle error
    }
}
```

### Searching for Media Content

```swift
let mediaService = MediaService.create(for: .gifs)

Task {
    do {
        let results = try await mediaService.search(query: "funny cats", page: 1, perPage: 20)
        // Process search results
    } catch {
        // Handle error
    }
}
```

## Error Handling

The module provides structured error handling:

* `NetworkLayerError` - For networking issues
* `APIError` - For business logic and server errors
* Clear error mapping for descriptive error messages

## Integration Points

The Infrastructure module integrates with:

1. **Networking Layer**
   * Through `RestApiProtocol` and `KlipyTargetType`
   * Using Moya for API communication

2. **UI Layer**
   * Provides domain models consumed by ViewModels
   * Async interfaces for responsive UI

3. **Analytics**
   * Media view and share tracking
   * Content reporting