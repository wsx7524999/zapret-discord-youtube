# Quick Start Guide

Get up and running with YouTube iOS Player and ML Metadata in 5 minutes!

## Prerequisites

- Xcode 14.0+
- iOS 15.0+ deployment target
- Swift 5.9+
- CocoaPods or Swift Package Manager

## Installation

### Swift Package Manager (Fastest)

1. Open your Xcode project
2. File → Add Packages
3. Enter: `https://github.com/wsx7524999/zapret-discord-youtube`
4. Navigate to `ios-app` subdirectory
5. Click "Add Package"

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'youtube-ios-player-helper', '~> 1.0'
```

Then run:
```bash
pod install
```

Copy the source files from `ios-app/YouTubePlayerApp/Sources/YouTubePlayerApp/` to your project.

## Your First Video Player (5 Steps)

### Step 1: Import the Library

```swift
import UIKit
import YouTubePlayerApp
```

### Step 2: Create a View Controller

```swift
class MyVideoViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
```

### Step 3: Add the Player View

```swift
func setupPlayer() {
    let playerView = playerManager.createPlayerView(
        frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
    )
    view.addSubview(playerView)
}
```

### Step 4: Load a Video

```swift
func loadVideo() {
    playerManager.loadVideo(videoId: "dQw4w9WgXcQ")
}
```

### Step 5: Play!

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupPlayer()
    loadVideo()
    playerManager.play()  // Start playing!
}
```

## Complete Working Example

```swift
import UIKit
import YouTubePlayerApp

class QuickStartViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "YouTube Player"
        
        // Setup player
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Load and play video
        playerManager.loadVideo(videoId: "dQw4w9WgXcQ")
        playerManager.play()
        
        // Add controls
        setupControls()
    }
    
    func setupControls() {
        // Play button
        let playBtn = UIButton(frame: CGRect(x: 20, y: 420, width: 100, height: 44))
        playBtn.setTitle("Play", for: .normal)
        playBtn.backgroundColor = .systemBlue
        playBtn.layer.cornerRadius = 8
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
        view.addSubview(playBtn)
        
        // Pause button
        let pauseBtn = UIButton(frame: CGRect(x: 130, y: 420, width: 100, height: 44))
        pauseBtn.setTitle("Pause", for: .normal)
        pauseBtn.backgroundColor = .systemOrange
        pauseBtn.layer.cornerRadius = 8
        pauseBtn.addTarget(self, action: #selector(pause), for: .touchUpInside)
        view.addSubview(pauseBtn)
    }
    
    @objc func play() {
        playerManager.play()
    }
    
    @objc func pause() {
        playerManager.pause()
    }
}
```

## Adding ML Metadata (Bonus!)

Enhance your player with ML-powered metadata:

```swift
import YouTubePlayerApp

class MLEnhancedViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let metadataManager = MLMetadataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerWithMetadata()
    }
    
    func setupPlayerWithMetadata() {
        // Create player
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Create metadata
        let metadata = VideoMetadata(
            title: "Awesome Tutorial",
            description: "Learn something great",
            tags: ["tutorial", "education"],
            duration: 600
        )
        
        // Enrich with ML
        let enriched = metadataManager.enrichMetadata(metadata)
        
        print("Category: \(enriched.category)")
        print("ML Tags: \(enriched.mlGeneratedTags)")
        print("Sentiment: \(enriched.sentiment)")
        
        // Load video
        playerManager.loadVideo(videoId: "YOUR_VIDEO_ID", metadata: metadata)
        playerManager.play()
    }
}
```

## Next Steps

Now that you have a working player, explore:

1. **[Full Documentation](README.md)** - Complete API reference
2. **[Integration Guide](INTEGRATION_GUIDE.md)** - Advanced integration patterns
3. **[Examples](EXAMPLES.md)** - More code examples
4. **[Configuration](CONFIGURATION.md)** - Customize your setup

## Common Issues

### Video not loading?
- Check your video ID is correct
- Ensure internet connectivity
- Add YouTube domains to `Info.plist` (see Configuration guide)

### Build errors?
- Clean build folder (⌘+Shift+K)
- Update dependencies
- Check iOS deployment target is 15.0+

## Getting Help

- 📖 [Full Documentation](README.md)
- 🐛 [Report Issues](https://github.com/wsx7524999/zapret-discord-youtube/issues)
- 💬 [Discussions](https://github.com/wsx7524999/zapret-discord-youtube/discussions)

## Summary

You learned how to:
- ✅ Install the YouTube player integration
- ✅ Create a basic video player in 5 steps
- ✅ Add playback controls
- ✅ Enhance with ML metadata

Happy coding! 🚀
