# iOS YouTube Player Integration

This directory contains the iOS application component for integrating YouTube video playback with ML-powered metadata management.

## 📚 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get started in 5 minutes
- **[API Reference](API_REFERENCE.md)** - Complete API documentation
- **[Integration Guide](INTEGRATION_GUIDE.md)** - Detailed integration instructions
- **[Configuration](CONFIGURATION.md)** - Setup and configuration options
- **[Examples](EXAMPLES.md)** - Code examples and use cases
- **[Changelog](CHANGELOG.md)** - Version history and updates

## Overview

The iOS integration adds YouTube video playback functionality and ML-based metadata enrichment to the zapret-discord-youtube repository. This component is separate from the Windows-based network filtering tool and provides iOS developers with a ready-to-use YouTube player implementation.

## Features

- **YouTube Video Playback**: Full integration with YouTube iOS Player Helper for seamless video playback
- **ML Metadata Processing**: Automatic metadata enrichment with category classification, sentiment analysis, and tag generation
- **Easy Integration**: Simple API for embedding YouTube videos in iOS applications
- **Metadata Management**: Organize and enrich video-related data with ML-powered analysis

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.9+
- CocoaPods (for CocoaPods installation) or Swift Package Manager

## Installation

### Option 1: Swift Package Manager (Recommended)

1. Open your project in Xcode
2. Go to File > Add Packages
3. Add the repository URL or use the local Package.swift
4. Select the version you want to use

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(path: "./ios-app")
]
```

### Option 2: CocoaPods

1. Navigate to the `ios-app` directory
2. Run `pod install`
3. Open the generated `.xcworkspace` file

```bash
cd ios-app
pod install
```

## Usage

### Basic YouTube Player Setup

```swift
import YouTubePlayerApp

class MyViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create player view
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Load a video
        playerManager.loadVideo(videoId: "dQw4w9WgXcQ")
    }
    
    func playVideo() {
        playerManager.play()
    }
    
    func pauseVideo() {
        playerManager.pause()
    }
}
```

### YouTube Player with Metadata

```swift
import YouTubePlayerApp

// Create metadata for your video
let metadata = VideoMetadata(
    title: "My Awesome Video",
    description: "This is a great tutorial video",
    tags: ["tutorial", "ios", "swift"],
    duration: 300,
    uploadDate: Date()
)

// Load video with metadata
playerManager.loadVideo(videoId: "VIDEO_ID", metadata: metadata)
```

### ML Metadata Enrichment

```swift
import YouTubePlayerApp

let metadataManager = MLMetadataManager.shared

// Create base metadata
let metadata = VideoMetadata(
    title: "iOS Development Tutorial",
    description: "Learn how to build great iOS apps",
    tags: ["ios", "swift", "development"],
    duration: 600
)

// Enrich with ML-generated tags and categories
let enrichedMetadata = metadataManager.enrichMetadata(metadata)

print("Category: \(enrichedMetadata.category)")
print("ML Tags: \(enrichedMetadata.mlGeneratedTags)")
print("Sentiment: \(enrichedMetadata.sentiment)")
print("Confidence: \(enrichedMetadata.confidence)")
```

### Complete Example

```swift
import UIKit
import YouTubePlayerApp

class ExampleViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let metadataManager = MLMetadataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAndLoadVideo()
    }
    
    func setupAndLoadVideo() {
        // Create player
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Create and enrich metadata
        let metadata = VideoMetadata(
            title: "Amazing Music Video",
            description: "This is an awesome music video with great sound",
            tags: ["music", "entertainment"],
            duration: 240
        )
        
        let enrichedMetadata = metadataManager.enrichMetadata(metadata)
        
        // Load video with enriched metadata
        playerManager.loadVideo(videoId: "VIDEO_ID", metadata: metadata)
        
        // Display enriched information
        displayEnrichedInfo(enrichedMetadata)
    }
    
    func displayEnrichedInfo(_ metadata: EnrichedMetadata) {
        print("Video Category: \(metadata.category)")
        print("Sentiment: \(metadata.sentiment)")
        print("ML Generated Tags: \(metadata.mlGeneratedTags.joined(separator: ", "))")
    }
}
```

## API Reference

### YouTubePlayerManager

Main class for managing YouTube video playback.

#### Methods

- `createPlayerView(frame: CGRect) -> YouTubePlayerView`
  - Creates and returns a configured YouTube player view

- `loadVideo(videoId: String, metadata: VideoMetadata? = nil)`
  - Loads a YouTube video by ID with optional metadata

- `play()`
  - Starts or resumes video playback

- `pause()`
  - Pauses video playback

- `stop()`
  - Stops video playback

- `getMetadata() -> VideoMetadata?`
  - Returns current video metadata

- `clear()`
  - Clears the player and metadata

### MLMetadataManager

Singleton class for ML-powered metadata enrichment.

#### Methods

- `enrichMetadata(_ metadata: VideoMetadata) -> EnrichedMetadata`
  - Enriches video metadata with ML-generated tags, categories, and sentiment

- `getMetadata(forKey key: String) -> EnrichedMetadata?`
  - Retrieves stored enriched metadata

- `getAllMetadata() -> [String: EnrichedMetadata]`
  - Returns all stored metadata

- `clearAllMetadata()`
  - Clears all stored metadata

### VideoMetadata

Structure containing basic video information.

#### Properties

- `title: String` - Video title
- `description: String` - Video description
- `tags: [String]` - Array of tags
- `duration: TimeInterval` - Video duration in seconds
- `uploadDate: Date?` - Optional upload date

### EnrichedMetadata

Structure containing enriched metadata with ML-generated data.

#### Properties

- `baseMetadata: VideoMetadata` - Original metadata
- `mlGeneratedTags: [String]` - ML-generated tags
- `category: String` - Classified category
- `sentiment: String` - Sentiment analysis result
- `confidence: Double` - Confidence score (0.0 - 1.0)

## Architecture

```
ios-app/
├── Package.swift                    # Swift Package Manager configuration
├── Podfile                         # CocoaPods configuration
└── YouTubePlayerApp/
    ├── Sources/
    │   └── YouTubePlayerApp/
    │       ├── YouTubePlayerManager.swift      # YouTube player management
    │       ├── MLMetadataManager.swift         # ML metadata processing
    │       └── YouTubePlayerViewController.swift # Example view controller
    └── Tests/
        └── YouTubePlayerAppTests/
```

## Dependencies

### YouTube iOS Player Helper

The YouTube iOS Player Helper is an open-source library that allows you to embed YouTube videos in iOS applications.

- **Repository**: https://github.com/youtube/youtube-ios-player-helper
- **License**: Apache 2.0
- **Version**: 1.0.4+

### ML Metadata

ML Metadata functionality is implemented natively in Swift for iOS. The `MLMetadataManager` provides:

- Automatic tag generation
- Category classification
- Sentiment analysis
- Metadata storage and retrieval

For more advanced ML operations, you can integrate TensorFlow Lite:

```ruby
pod 'TensorFlowLiteSwift', '~> 2.13.0'
```

## Workflow Integration

### 1. Basic Video Playback

```swift
// Initialize manager
let manager = YouTubePlayerManager()

// Create and add player view
let player = manager.createPlayerView(frame: playerFrame)
view.addSubview(player)

// Load and play video
manager.loadVideo(videoId: "VIDEO_ID")
manager.play()
```

### 2. Metadata Processing Pipeline

```swift
// Create base metadata
let metadata = VideoMetadata(...)

// Enrich with ML
let enriched = MLMetadataManager.shared.enrichMetadata(metadata)

// Use enriched data
processEnrichedMetadata(enriched)
```

### 3. Combined Workflow

```swift
// 1. Create metadata
let metadata = VideoMetadata(...)

// 2. Enrich with ML
let enriched = MLMetadataManager.shared.enrichMetadata(metadata)

// 3. Load video with metadata
playerManager.loadVideo(videoId: "VIDEO_ID", metadata: metadata)

// 4. Use enriched data for UI/Analytics
updateUI(with: enriched)
```

## Testing

Run tests using Xcode or Swift Package Manager:

```bash
cd ios-app
swift test
```

## Best Practices

1. **Player Lifecycle**: Always clear the player when the view controller is deallocated
2. **Metadata Caching**: Use `MLMetadataManager` to cache enriched metadata
3. **Error Handling**: Implement proper error handling for video loading failures
4. **Memory Management**: Release player resources when not in use

## Troubleshooting

### Video Not Playing

- Ensure you have a valid YouTube video ID
- Check internet connectivity
- Verify the video is not restricted in your region

### Build Errors

- Clean build folder (Cmd+Shift+K)
- Update dependencies: `pod update` or resolve Swift packages
- Ensure deployment target is iOS 15.0+

## Contributing

Contributions are welcome! Please ensure:

1. Code follows Swift style guidelines
2. All tests pass
3. Documentation is updated
4. Commit messages are descriptive

## License

This iOS integration follows the same MIT license as the parent repository. See [LICENSE.txt](../LICENSE.txt) for details.

## Support

For issues specific to:
- YouTube Player: https://github.com/youtube/youtube-ios-player-helper/issues
- This integration: https://github.com/wsx7524999/zapret-discord-youtube/issues

## Acknowledgments

- YouTube iOS Player Helper team
- Original zapret developers
- Contributors to this integration
