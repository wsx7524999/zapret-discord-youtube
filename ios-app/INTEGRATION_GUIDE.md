# Integration Guide: YouTube iOS Player Helper & ML Metadata

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation Options](#installation-options)
4. [API Workflow](#api-workflow)
5. [Configuration](#configuration)
6. [Example Projects](#example-projects)
7. [Advanced Usage](#advanced-usage)
8. [Troubleshooting](#troubleshooting)

## Introduction

This guide provides step-by-step instructions for integrating the YouTube iOS Player Helper and ML Metadata functionality into your iOS application.

### What's Included

- **YouTube Player Integration**: Embed and control YouTube videos
- **ML Metadata Processing**: Automatic video classification and tagging
- **Swift API**: Modern, type-safe Swift interfaces
- **Example Code**: Ready-to-use code samples

### Finding YouTube Video IDs

YouTube video IDs are 11-character alphanumeric strings found in video URLs:

- From URL: `https://www.youtube.com/watch?v=dQw4w9WgXcQ`
- Video ID: `dQw4w9WgXcQ`

You can extract the ID from:
- Standard URLs: After `v=` parameter
- Short URLs: `youtu.be/VIDEO_ID`
- Embed URLs: `/embed/VIDEO_ID`

## Prerequisites

Before you begin, ensure you have:

- **Xcode**: Version 14.0 or later
- **iOS Deployment Target**: iOS 15.0+
- **Swift**: Version 5.9+
- **CocoaPods**: (Optional) Version 1.11.0+ for CocoaPods installation
- **Basic Swift Knowledge**: Understanding of UIKit and view controllers

## Installation Options

### Option 1: Swift Package Manager (Recommended)

#### Step 1: Add Package to Your Project

1. Open your Xcode project
2. Click **File** → **Add Packages...**
3. Enter the repository URL or navigate to local package
4. Select version/branch
5. Click **Add Package**

#### Step 2: Import in Your Code

```swift
import YouTubePlayerApp
```

### Option 2: CocoaPods

#### Step 1: Create/Update Podfile

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'youtube-ios-player-helper', '~> 1.0'
end
```

#### Step 2: Install Pods

```bash
cd YourProjectDirectory
pod install
```

#### Step 3: Open Workspace

```bash
open YourProject.xcworkspace
```

#### Step 4: Copy Integration Files

Copy the following files from `ios-app/YouTubePlayerApp/Sources/YouTubePlayerApp/`:
- `YouTubePlayerManager.swift`
- `MLMetadataManager.swift`
- `YouTubePlayerViewController.swift` (optional example)

### Option 3: Manual Integration

1. Copy the source files to your project
2. Add YouTube iOS Player Helper manually or via CocoaPods
3. Configure build settings

## API Workflow

### Complete Integration Workflow

```
┌─────────────────────────────────────────────────────┐
│           Your iOS Application                      │
│                                                      │
│  ┌────────────────────────────────────────────┐   │
│  │   1. Create VideoMetadata                   │   │
│  │      - Title, description, tags, duration   │   │
│  └──────────────┬─────────────────────────────┘   │
│                 │                                    │
│                 ▼                                    │
│  ┌────────────────────────────────────────────┐   │
│  │   2. Enrich with ML (MLMetadataManager)    │   │
│  │      - Generate ML tags                     │   │
│  │      - Classify category                    │   │
│  │      - Analyze sentiment                    │   │
│  └──────────────┬─────────────────────────────┘   │
│                 │                                    │
│                 ▼                                    │
│  ┌────────────────────────────────────────────┐   │
│  │   3. Setup Player (YouTubePlayerManager)   │   │
│  │      - Create player view                   │   │
│  │      - Load video with metadata             │   │
│  └──────────────┬─────────────────────────────┘   │
│                 │                                    │
│                 ▼                                    │
│  ┌────────────────────────────────────────────┐   │
│  │   4. Display & Control                      │   │
│  │      - Show enriched metadata               │   │
│  │      - Control playback (play/pause/stop)   │   │
│  └────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

### Step-by-Step API Workflow

#### Step 1: Initialize Managers

```swift
import UIKit
import YouTubePlayerApp

class VideoViewController: UIViewController {
    // Initialize managers
    private let playerManager = YouTubePlayerManager()
    private let metadataManager = MLMetadataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }
}
```

#### Step 2: Create Video Metadata

```swift
func createVideoMetadata() -> VideoMetadata {
    return VideoMetadata(
        title: "iOS Development Best Practices",
        description: "Learn the best practices for iOS development with Swift",
        tags: ["ios", "swift", "development", "tutorial"],
        duration: 600, // 10 minutes in seconds
        uploadDate: Date()
    )
}
```

#### Step 3: Enrich Metadata with ML

```swift
func enrichAndStoreMetadata(_ metadata: VideoMetadata) -> EnrichedMetadata {
    // ML processing automatically generates:
    // - Additional tags based on content analysis
    // - Category classification
    // - Sentiment analysis
    let enriched = metadataManager.enrichMetadata(metadata)
    
    print("Original tags: \(metadata.tags)")
    print("ML-generated tags: \(enriched.mlGeneratedTags)")
    print("Category: \(enriched.category)")
    print("Sentiment: \(enriched.sentiment)")
    
    return enriched
}
```

#### Step 4: Setup YouTube Player

```swift
func setupVideoPlayer() {
    // Create player view with desired frame
    let playerFrame = CGRect(
        x: 0,
        y: 100,
        width: view.bounds.width,
        height: 300
    )
    
    let playerView = playerManager.createPlayerView(frame: playerFrame)
    view.addSubview(playerView)
}
```

#### Step 5: Load and Play Video

```swift
func loadAndPlayVideo(videoId: String) {
    // Create and enrich metadata
    let metadata = createVideoMetadata()
    let enriched = enrichAndStoreMetadata(metadata)
    
    // Load video
    playerManager.loadVideo(videoId: videoId, metadata: metadata)
    
    // Display enriched information
    displayMetadata(enriched)
    
    // Start playback
    playerManager.play()
}
```

#### Step 6: Control Playback

```swift
// Play
@objc func playButtonTapped() {
    playerManager.play()
}

// Pause
@objc func pauseButtonTapped() {
    playerManager.pause()
}

// Stop
@objc func stopButtonTapped() {
    playerManager.stop()
}

// Clear
func cleanup() {
    playerManager.clear()
}
```

## Configuration

### Basic Configuration

```swift
// Configure in AppDelegate or SceneDelegate
func application(_ application: UIApplication, 
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Pre-load metadata if needed
    initializeMetadataStore()
    
    return true
}

func initializeMetadataStore() {
    // Pre-populate metadata for frequently accessed videos
    let videos = [
        ("videoId1", VideoMetadata(...)),
        ("videoId2", VideoMetadata(...))
    ]
    
    for (_, metadata) in videos {
        _ = MLMetadataManager.shared.enrichMetadata(metadata)
    }
}
```

### Advanced Configuration

```swift
// Custom player configuration
class CustomPlayerViewController: UIViewController {
    
    func setupAdvancedPlayer() {
        let player = playerManager.createPlayerView(frame: playerFrame)
        
        // Configure player appearance
        player.backgroundColor = .black
        
        // Add to view hierarchy
        view.addSubview(player)
        
        // Setup constraints (if using Auto Layout)
        setupPlayerConstraints(player)
    }
}
```

## Example Projects

### Example 1: Simple Video Player

```swift
import UIKit
import YouTubePlayerApp

class SimplePlayerViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup player
        let player = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(player)
        
        // Load video
        playerManager.loadVideo(videoId: "dQw4w9WgXcQ")
        playerManager.play()
    }
}
```

### Example 2: Video with ML Metadata

```swift
import UIKit
import YouTubePlayerApp

class MLEnhancedPlayerViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let metadataManager = MLMetadataManager.shared
    
    var metadataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadVideoWithMetadata()
    }
    
    func setupUI() {
        // Setup player
        let player = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(player)
        
        // Setup metadata label
        metadataLabel = UILabel(frame: CGRect(x: 20, y: 420, width: view.bounds.width - 40, height: 200))
        metadataLabel.numberOfLines = 0
        view.addSubview(metadataLabel)
    }
    
    func loadVideoWithMetadata() {
        // Create metadata
        let metadata = VideoMetadata(
            title: "Awesome Tutorial",
            description: "Learn something great with this awesome tutorial",
            tags: ["tutorial", "education"],
            duration: 480
        )
        
        // Enrich with ML
        let enriched = metadataManager.enrichMetadata(metadata)
        
        // Display enriched info
        metadataLabel.text = """
        Title: \(enriched.baseMetadata.title)
        Category: \(enriched.category)
        Sentiment: \(enriched.sentiment)
        ML Tags: \(enriched.mlGeneratedTags.joined(separator: ", "))
        """
        
        // Load and play
        playerManager.loadVideo(videoId: "YOUR_VIDEO_ID", metadata: metadata)
        playerManager.play()
    }
}
```

### Example 3: Video List with Metadata

```swift
import UIKit
import YouTubePlayerApp

class VideoListViewController: UITableViewController {
    let metadataManager = MLMetadataManager.shared
    var videos: [(id: String, metadata: EnrichedMetadata)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideos()
    }
    
    func loadVideos() {
        let videoList = [
            ("video1", VideoMetadata(title: "Music Video", description: "Great music", tags: ["music"], duration: 200)),
            ("video2", VideoMetadata(title: "Gaming Stream", description: "Epic gameplay", tags: ["gaming"], duration: 3600)),
            ("video3", VideoMetadata(title: "Tutorial", description: "Learn Swift", tags: ["tutorial"], duration: 900))
        ]
        
        videos = videoList.map { (id, metadata) in
            let enriched = metadataManager.enrichMetadata(metadata)
            return (id, enriched)
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        let video = videos[indexPath.row]
        
        cell.textLabel?.text = video.metadata.baseMetadata.title
        cell.detailTextLabel?.text = "\(video.metadata.category) - \(video.metadata.sentiment)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        showVideoPlayer(videoId: video.id, metadata: video.metadata)
    }
    
    func showVideoPlayer(videoId: String, metadata: EnrichedMetadata) {
        let playerVC = YouTubePlayerViewController()
        // Configure with video and metadata
        present(playerVC, animated: true)
    }
}
```

## Advanced Usage

### Custom ML Tag Generation

You can extend the `MLMetadataManager` with custom tag generation logic:

```swift
extension MLMetadataManager {
    func generateCustomTags(from metadata: VideoMetadata) -> [String] {
        var customTags: [String] = []
        
        // Your custom logic here
        if metadata.duration > 600 {
            customTags.append("long-form")
        }
        
        if metadata.tags.contains("live") {
            customTags.append("live-stream")
        }
        
        return customTags
    }
}
```

### Persistence

Save enriched metadata for offline access:

```swift
func saveMetadata(_ metadata: EnrichedMetadata, forKey key: String) {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(metadata) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

func loadMetadata(forKey key: String) -> EnrichedMetadata? {
    guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
    let decoder = JSONDecoder()
    return try? decoder.decode(EnrichedMetadata.self, from: data)
}
```

## Troubleshooting

### Common Issues

#### Issue: Player not loading videos

**Solution:**
- Verify video ID is correct
- Check internet connectivity
- Ensure YouTube video is not region-restricted
- Check for API key requirements (YouTube API)

#### Issue: ML metadata not generating correctly

**Solution:**
- Ensure metadata has sufficient information (title, description)
- Check that tags are relevant
- Verify MLMetadataManager is properly initialized

#### Issue: Build errors after integration

**Solution:**
- Clean build folder (⌘ + Shift + K)
- Update all dependencies
- Check deployment target is iOS 15.0+
- Verify import statements

#### Issue: Memory warnings with multiple videos

**Solution:**
- Clear player when not in use: `playerManager.clear()`
- Implement pagination for video lists
- Clear metadata cache periodically: `metadataManager.clearAllMetadata()`

### Debug Tips

Enable logging:
```swift
func debugPlayerState() {
    if let metadata = playerManager.getMetadata() {
        print("Current video: \(metadata.title)")
    }
    
    let allMetadata = metadataManager.getAllMetadata()
    print("Stored metadata count: \(allMetadata.count)")
}
```

## Support

For issues and questions:
- GitHub Issues: https://github.com/wsx7524999/zapret-discord-youtube/issues
- YouTube Player Helper: https://github.com/youtube/youtube-ios-player-helper

## Next Steps

1. Review the API documentation in [README.md](README.md)
2. Explore example implementations
3. Customize ML metadata generation for your use case
4. Implement persistence for offline support
5. Add analytics tracking

## Conclusion

You now have a complete YouTube player integration with ML-powered metadata management. The workflow provides:

✅ Easy video playback integration
✅ Automatic metadata enrichment
✅ Type-safe Swift API
✅ Extensible architecture
✅ Production-ready code

Happy coding! 🚀
