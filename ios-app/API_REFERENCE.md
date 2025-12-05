# API Reference

Complete API documentation for YouTube Player and ML Metadata integration.

## Table of Contents

- [YouTubePlayerManager](#youtubeplayermanager)
- [MLMetadataManager](#mlmetadatamanager)
- [Data Structures](#data-structures)
- [Protocols](#protocols)

---

## YouTubePlayerManager

Main class for managing YouTube video playback.

### Overview

`YouTubePlayerManager` provides a high-level interface for embedding and controlling YouTube videos in your iOS application.

```swift
public class YouTubePlayerManager: NSObject
```

### Initialization

```swift
public override init()
```

Creates a new instance of `YouTubePlayerManager`.

**Example:**
```swift
let playerManager = YouTubePlayerManager()
```

### Methods

#### createPlayerView(frame:)

Creates and configures a YouTube player view.

```swift
public func createPlayerView(frame: CGRect) -> YouTubePlayerView
```

**Parameters:**
- `frame`: The frame rectangle for the player view

**Returns:** Configured `YouTubePlayerView` instance

**Example:**
```swift
let playerView = playerManager.createPlayerView(
    frame: CGRect(x: 0, y: 100, width: 375, height: 300)
)
view.addSubview(playerView)
```

---

#### loadVideo(videoId:metadata:)

Loads a YouTube video by ID with optional metadata.

```swift
public func loadVideo(videoId: String, metadata: VideoMetadata? = nil)
```

**Parameters:**
- `videoId`: The YouTube video identifier (e.g., "dQw4w9WgXcQ")
- `metadata`: Optional video metadata (default: nil)

**Example:**
```swift
// Load without metadata
playerManager.loadVideo(videoId: "dQw4w9WgXcQ")

// Load with metadata
let metadata = VideoMetadata(
    title: "My Video",
    description: "Video description",
    tags: ["tag1", "tag2"],
    duration: 300
)
playerManager.loadVideo(videoId: "dQw4w9WgXcQ", metadata: metadata)
```

---

#### play()

Starts or resumes video playback.

```swift
public func play()
```

**Example:**
```swift
playerManager.play()
```

---

#### pause()

Pauses video playback.

```swift
public func pause()
```

**Example:**
```swift
playerManager.pause()
```

---

#### stop()

Stops video playback and resets the player.

```swift
public func stop()
```

**Example:**
```swift
playerManager.stop()
```

---

#### getMetadata()

Returns the current video metadata if available.

```swift
public func getMetadata() -> VideoMetadata?
```

**Returns:** `VideoMetadata` if metadata was set, otherwise `nil`

**Example:**
```swift
if let metadata = playerManager.getMetadata() {
    print("Current video: \(metadata.title)")
}
```

---

#### clear()

Clears the player and removes all metadata.

```swift
public func clear()
```

**Example:**
```swift
playerManager.clear()
```

---

## MLMetadataManager

Singleton class for ML-powered metadata enrichment and management.

### Overview

`MLMetadataManager` provides automatic video metadata enrichment using machine learning techniques including category classification, sentiment analysis, and tag generation.

```swift
public class MLMetadataManager
```

### Properties

#### shared

Singleton instance of the metadata manager.

```swift
public static let shared: MLMetadataManager
```

**Example:**
```swift
let manager = MLMetadataManager.shared
```

### Methods

#### enrichMetadata(_:)

Enriches video metadata with ML-generated tags, categories, and sentiment analysis.

```swift
public func enrichMetadata(_ metadata: VideoMetadata) -> EnrichedMetadata
```

**Parameters:**
- `metadata`: Base video metadata to enrich

**Returns:** `EnrichedMetadata` containing original data plus ML-generated information

**ML Features:**
- **Tag Generation**: Automatically generates relevant tags based on title and description
- **Category Classification**: Classifies video into categories (Music, Gaming, Education, Entertainment, General)
- **Sentiment Analysis**: Analyzes sentiment as positive, negative, or neutral
- **Confidence Score**: Provides confidence level (0.0 - 1.0) for the analysis

**Example:**
```swift
let metadata = VideoMetadata(
    title: "iOS Development Tutorial",
    description: "Learn iOS development with this awesome tutorial",
    tags: ["ios", "swift"],
    duration: 600
)

let enriched = MLMetadataManager.shared.enrichMetadata(metadata)

print("Category: \(enriched.category)")          // "Education"
print("ML Tags: \(enriched.mlGeneratedTags)")    // ["tutorial", "education"]
print("Sentiment: \(enriched.sentiment)")        // "positive"
print("Confidence: \(enriched.confidence)")      // 0.85
```

---

#### getMetadata(forKey:)

Retrieves previously enriched metadata by key.

```swift
public func getMetadata(forKey key: String) -> EnrichedMetadata?
```

**Parameters:**
- `key`: Unique identifier for the metadata

**Returns:** `EnrichedMetadata` if found, otherwise `nil`

**Example:**
```swift
if let metadata = manager.getMetadata(forKey: "unique-key") {
    print("Found cached metadata: \(metadata.baseMetadata.title)")
}
```

---

#### getAllMetadata()

Returns all stored enriched metadata.

```swift
public func getAllMetadata() -> [String: EnrichedMetadata]
```

**Returns:** Dictionary mapping keys to enriched metadata

**Example:**
```swift
let allMetadata = manager.getAllMetadata()
print("Cached items: \(allMetadata.count)")

for (key, metadata) in allMetadata {
    print("\(key): \(metadata.baseMetadata.title)")
}
```

---

#### clearAllMetadata()

Removes all stored metadata from the cache.

```swift
public func clearAllMetadata()
```

**Example:**
```swift
manager.clearAllMetadata()
print("Cache cleared")
```

---

## Data Structures

### VideoMetadata

Structure containing basic video information.

```swift
public struct VideoMetadata: Codable
```

#### Properties

```swift
public let title: String
public let description: String
public let tags: [String]
public let duration: TimeInterval
public let uploadDate: Date?
```

#### Initializer

```swift
public init(
    title: String,
    description: String,
    tags: [String],
    duration: TimeInterval,
    uploadDate: Date? = nil
)
```

#### Example

```swift
let metadata = VideoMetadata(
    title: "My Awesome Video",
    description: "This is a great video about Swift programming",
    tags: ["swift", "ios", "programming"],
    duration: 1200,
    uploadDate: Date()
)
```

---

### EnrichedMetadata

Structure containing enriched metadata with ML-generated data.

```swift
public struct EnrichedMetadata: Codable
```

#### Properties

```swift
public let baseMetadata: VideoMetadata
public let mlGeneratedTags: [String]
public let category: String
public let sentiment: String
public let confidence: Double
```

#### Categories

Possible category values:
- `"Music"` - Music videos, songs, audio content
- `"Gaming"` - Game streams, gameplay, gaming content
- `"Education"` - Tutorials, courses, educational content
- `"Entertainment"` - Comedy, entertainment, fun content
- `"General"` - Other content that doesn't fit specific categories

#### Sentiment Values

Possible sentiment values:
- `"positive"` - Positive sentiment detected
- `"negative"` - Negative sentiment detected
- `"neutral"` - Neutral sentiment (default)

#### Confidence

Confidence score ranges from 0.0 to 1.0:
- `0.0 - 0.5`: Low confidence
- `0.5 - 0.8`: Medium confidence
- `0.8 - 1.0`: High confidence

#### Initializer

```swift
public init(
    baseMetadata: VideoMetadata,
    mlGeneratedTags: [String],
    category: String,
    sentiment: String,
    confidence: Double
)
```

#### Example

```swift
let enriched = EnrichedMetadata(
    baseMetadata: videoMetadata,
    mlGeneratedTags: ["tutorial", "education", "technology"],
    category: "Education",
    sentiment: "positive",
    confidence: 0.85
)

print("Video is \(enriched.category) with \(enriched.sentiment) sentiment")
```

---

## Usage Patterns

### Basic Playback

```swift
let playerManager = YouTubePlayerManager()
let playerView = playerManager.createPlayerView(frame: ...)
view.addSubview(playerView)

playerManager.loadVideo(videoId: "VIDEO_ID")
playerManager.play()
```

### With Metadata Enrichment

```swift
let playerManager = YouTubePlayerManager()
let metadataManager = MLMetadataManager.shared

// Create metadata
let metadata = VideoMetadata(...)

// Enrich
let enriched = metadataManager.enrichMetadata(metadata)

// Use enriched data
print("Category: \(enriched.category)")

// Load video
playerManager.loadVideo(videoId: "VIDEO_ID", metadata: metadata)
```

### Caching Pattern

```swift
// First time: enrich and cache
let enriched = metadataManager.enrichMetadata(metadata)

// Later: retrieve from cache
let allCached = metadataManager.getAllMetadata()
```

### Persistence Pattern

```swift
// Save to UserDefaults
let encoder = JSONEncoder()
if let data = try? encoder.encode(enriched) {
    UserDefaults.standard.set(data, forKey: "video_metadata")
}

// Load from UserDefaults
let decoder = JSONDecoder()
if let data = UserDefaults.standard.data(forKey: "video_metadata"),
   let metadata = try? decoder.decode(EnrichedMetadata.self, from: data) {
    // Use metadata
}
```

---

## Error Handling

While the current API doesn't throw errors, it's recommended to implement defensive coding:

```swift
// Check for valid player view
guard let playerView = createPlayerView(...) else {
    print("Failed to create player view")
    return
}

// Verify metadata exists
if let metadata = playerManager.getMetadata() {
    // Use metadata
} else {
    print("No metadata available")
}

// Handle empty results
let allMetadata = metadataManager.getAllMetadata()
if allMetadata.isEmpty {
    print("No cached metadata")
}
```

---

## Threading Considerations

- **UI Operations**: All player view operations should be performed on the main thread
- **Metadata Processing**: ML metadata enrichment is synchronous and CPU-bound
- **Long Operations**: For processing many videos, consider background threads:

```swift
DispatchQueue.global(qos: .userInitiated).async {
    let enriched = metadataManager.enrichMetadata(metadata)
    
    DispatchQueue.main.async {
        // Update UI with enriched metadata
    }
}
```

---

## Memory Management

### Best Practices

1. **Clear Player**: Always clear the player when done
   ```swift
   playerManager.clear()
   ```

2. **Manage Cache**: Clear metadata cache periodically
   ```swift
   metadataManager.clearAllMetadata()
   ```

3. **Memory Warnings**: Handle memory warnings
   ```swift
   NotificationCenter.default.addObserver(
       forName: UIApplication.didReceiveMemoryWarningNotification,
       object: nil,
       queue: .main
   ) { _ in
       metadataManager.clearAllMetadata()
   }
   ```

---

## Version Compatibility

- **iOS**: 15.0+
- **Swift**: 5.9+
- **Xcode**: 14.0+
- **YouTube Player Helper**: 1.0.4+

---

## See Also

- [Quick Start Guide](QUICKSTART.md)
- [Integration Guide](INTEGRATION_GUIDE.md)
- [Examples](EXAMPLES.md)
- [Configuration](CONFIGURATION.md)
