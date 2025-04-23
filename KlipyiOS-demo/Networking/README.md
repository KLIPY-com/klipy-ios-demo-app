# Networking Module

The Networking module provides a robust, type-safe networking layer for the KlipyiOS-demo app, built on top of Moya and Alamofire. It handles API requests, response parsing, error handling, and provides modern Swift async/await support.

## Architecture

The module follows a layered architecture with clear separation of concerns:

```
Networking/
└── Core/
    ├── AsyncMoyaRequestWrapper.swift
    ├── Error/
    │   ├── APIErrorResponse.swift
    │   ├── ApiError.swift
    │   ├── ApiErrorWrapper.swift
    │   ├── MoyaErrorMapping.swift
    │   └── NetworkLayerErrorReason.swift
    ├── KlipyMultiTarget.swift
    ├── KlipyTargetType.swift
    ├── NetworkingProviderProtocol.swift
    └── RestApiProtocol.swift
```

## Key Components

### Core Protocols

#### `RestApiProtocol`

The main interface for API communication that hides implementation details:

```swift
public protocol RestApiProtocol {
  func request<ResponseType: Decodable>(_ target: any KlipyTargetType) async throws -> ResponseType
  var baseURL: URL { get }
}
```

#### `NetworkingProviderProtocol`

Generic protocol for network providers that handle the actual API requests:

```swift
public protocol NetworkingProviderProtocol {
  associatedtype Target: Moya.TargetType
  func request<ResponseType: Decodable>(_ target: Target, progress: @escaping ProgressBlock) async throws -> ResponseType
}
```

#### `KlipyTargetType`

Extension of Moya's `TargetType` with Klipy-specific requirements:

```swift
public protocol KlipyTargetType: Moya.TargetType {
  var mayRunAsBackgroundTask: Bool { get }
  var baseUrlSuffix: String { get }
  var overrideApiVersion: String? { get }
}
```

### Implementation Classes

#### `RestApi`

Concrete implementation of `RestApiProtocol` that delegates to the networking provider:

```swift
public final class RestApi: RestApiProtocol {
  public let baseURL: URL
  let provider: NetworkingProvider<KlipyMultiTarget>
  
  // Implementation...
}
```

#### `NetworkingProvider`

Generic implementation of `NetworkingProviderProtocol` that wraps Moya's provider:

```swift
public class NetworkingProvider<Target>: NetworkingProviderProtocol where Target: Moya.TargetType {
  private let provider: MoyaProvider<Target>
  
  // Implementation with async/await support...
}
```

#### `KlipyMultiTarget`

Multi-target wrapper that combines a base URL with a target to create complete requests:

```swift
struct KlipyMultiTarget: KlipyTargetType {
  private let _baseURL: URL
  public let target: any TargetType
  
  // Implementation...
}
```

### Async Support

#### `AsyncMoyaRequestWrapper`

Wrapper that converts Moya's callback-based API to Swift's async/await pattern:

```swift
class AsyncMoyaRequestWrapper {
  typealias MoyaContinuation = CheckedContinuation<Result<Response, MoyaError>, Never>
  
  var performRequest: (MoyaContinuation) -> (any Moya.Cancellable)?
  var cancellable: (any Moya.Cancellable)?
  
  // Implementation...
}
```

### Error Handling

The module provides a comprehensive error handling system:

#### `NetworkLayerErrorReason`

Enumeration of all possible network error reasons, including HTTP status codes:

```swift
public enum NetworkLayerErrorReason: Int, Equatable, CaseIterable, Sendable {
  // Basic error types
  case unknown
  case canceled
  case authorization
  // ...
  
  // HTTP status codes
  case ok = 200
  case created = 201
  // ...
  case unauthorized = 401
  case forbidden = 403
  case notFound = 404
  // ...
}
```

#### `ApiError`

Domain-specific error types that represent API-level errors:

```swift
public enum APIError: Error, Equatable {
  case predefined(APIErrorCode)
  case unknown(String, String)
  case generalError(String, NetworkLayerErrorReason)
  case other(NetworkLayerError)
  case handled
  case custom(errorMessage: String, isPermanentlyBlocked: Bool, unlockTimeUTC: String?)
}
```

#### `NetworkLayerError`

Structured error type that combines error reason, status code, and additional details:

```swift
public struct NetworkLayerError: Error {
  public let reason: NetworkLayerErrorReason
  public let moyaError: MoyaError
  public let statusCode: Int
  public let apiErrorItem: ApiErrorItem?
}
```

## Usage

### Basic API Request

```swift
// Create an instance of RestApi
let restApi: RestApiProtocol = RestApi(
  baseURL: URL(string: "https://api.klipy.co/api/v1/sandbox-mJokm7E2jH")!,
  provider: NetworkingProvider()
)

// Define a target
enum MyService: KlipyTargetType {
  case getData(id: String)
  
  var path: String {
    switch self {
    case .getData(let id):
      return "/data/\(id)"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var task: Moya.Task {
    return .requestPlain
  }
}

// Make the request with async/await
func fetchData(id: String) async throws -> MyDataModel {
  return try await restApi.request(MyService.getData(id: id))
}
```

### Error Handling

```swift
do {
  let result = try await fetchData(id: "123")
  // Handle success
} catch let error as APIError {
  switch error {
  case .predefined(.sessionNotFound):
    // Handle session not found
  case .generalError(let message, let reason):
    // Handle general error
  case .other(let networkError):
    // Handle network layer error
  default:
    // Handle other errors
  }
} catch {
  // Handle unexpected errors
}
```

## Design Principles

1. **Type Safety**: Using Swift's type system to prevent runtime errors
2. **Protocol-Oriented**: Clear interfaces that allow for testability and extensibility
3. **Modern Swift**: Full support for async/await and Swift Concurrency
4. **Clean Error Handling**: Structured error types with rich information
5. **Cancellable Requests**: Support for cancelling in-flight requests

## Integration Points

- **Infrastructure Layer**: The networking module is used by the Infrastructure layer's services
- **Moya**: Built on the Moya networking abstraction library
- **Alamofire**: Leverages Alamofire for underlying HTTP communication