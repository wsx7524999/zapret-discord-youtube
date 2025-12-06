# iOS App Configuration Examples

## Swift Package Manager Configuration

### Basic Package.swift

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "YouTubePlayerApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "YouTubePlayerApp",
            targets: ["YouTubePlayerApp"]
        ),
    ],
    dependencies: [
        // Using upToNextMinor to allow patch updates (1.0.x) while maintaining API compatibility
        .package(url: "https://github.com/youtube/youtube-ios-player-helper.git", .upToNextMinor(from: "1.0.4")),
    ],
    targets: [
        .target(
            name: "YouTubePlayerApp",
            dependencies: [
                .product(name: "YouTubePlayer", package: "youtube-ios-player-helper")
            ]
        ),
        .testTarget(
            name: "YouTubePlayerAppTests",
            dependencies: ["YouTubePlayerApp"]
        ),
    ]
)
```

### With Additional Dependencies

```swift
dependencies: [
    .package(url: "https://github.com/youtube/youtube-ios-player-helper.git", .upToNextMinor(from: "1.0.4")),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from: "5.8.0")),
]
```

## CocoaPods Configuration

### Basic Podfile

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YouTubePlayerApp' do
  pod 'youtube-ios-player-helper', '~> 1.0'
end
```

### With Additional Pods

```ruby
platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

target 'YouTubePlayerApp' do
  # YouTube Player
  pod 'youtube-ios-player-helper', '~> 1.0'
  
  # Networking (optional)
  pod 'Alamofire', '~> 5.8'
  
  # JSON parsing (optional)
  pod 'SwiftyJSON', '~> 5.0'
  
  # ML/AI (optional)
  pod 'TensorFlowLiteSwift', '~> 2.13.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

## Xcode Project Configuration

### Build Settings

```
IPHONEOS_DEPLOYMENT_TARGET = 15.0
SWIFT_VERSION = 5.9
ENABLE_BITCODE = NO
```

### Info.plist Additions

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>youtube.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
        <key>ytimg.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## Application Configuration

### AppDelegate Configuration

```swift
import UIKit
import YouTubePlayerApp

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, 
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Pre-configure ML Metadata Manager
        configureMetadataManager()
        
        return true
    }
    
    private func configureMetadataManager() {
        // Pre-warm the metadata manager
        let manager = MLMetadataManager.shared
        
        // Optionally pre-load common metadata
        loadCommonMetadata()
    }
    
    private func loadCommonMetadata() {
        // Pre-populate frequently accessed video metadata
        let commonVideos: [(String, VideoMetadata)] = [
            // Add your common videos here
        ]
        
        for (_, metadata) in commonVideos {
            _ = MLMetadataManager.shared.enrichMetadata(metadata)
        }
    }
}
```

### SceneDelegate Configuration (for SwiftUI or multi-window apps)

```swift
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, 
              willConnectTo session: UISceneSession,
              options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = YouTubePlayerViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
```

## Environment Configuration

### Development Environment

```swift
#if DEBUG
let isDebugMode = true
let enableVerboseLogging = true
#else
let isDebugMode = false
let enableVerboseLogging = false
#endif

// Use in your code
if enableVerboseLogging {
    print("Loading video: \(videoId)")
}
```

### Configuration File (Config.swift)

```swift
import Foundation

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    // API Keys (use environment variables in production)
    var youtubeAPIKey: String {
        return ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"] ?? ""
    }
    
    // Feature Flags
    let enableMLMetadata = true
    let enableOfflineMode = false
    let enableAnalytics = true
    
    // Player Settings
    let defaultPlayerQuality: String = "hd720"
    let autoPlayVideos = false
    let showPlayerControls = true
    
    // Metadata Settings
    let cacheMetadata = true
    let metadataCacheSize = 100
    let metadataExpirationTime: TimeInterval = 3600 // 1 hour
}
```

## Testing Configuration

### XCTest Configuration

```swift
import XCTest
@testable import YouTubePlayerApp

class TestConfiguration {
    static let testVideoId = "dQw4w9WgXcQ"
    static let testTimeout: TimeInterval = 10.0
    
    static func createTestMetadata() -> VideoMetadata {
        return VideoMetadata(
            title: "Test Video",
            description: "Test Description",
            tags: ["test"],
            duration: 100
        )
    }
}
```

### Test Scheme Configuration

In Xcode:
1. Product > Scheme > Edit Scheme
2. Test section
3. Add environment variables for testing

## Deployment Configuration

### App Store Configuration

```
Bundle Identifier: com.yourcompany.youtubeplayerapp
Version: 1.0.0
Build: 1
Deployment Target: iOS 15.0
Supported Devices: iPhone, iPad
Orientations: Portrait, Landscape
```

### Continuous Integration (CI/CD)

```yaml
# Example GitHub Actions workflow
name: iOS CI

on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build
      run: swift build
    - name: Test
      run: swift test
```

## Security Configuration

### Keychain Configuration for API Keys

```swift
import Security

class KeychainManager {
    static func saveAPIKey(_ key: String) {
        let data = key.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "YouTubeAPIKey",
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func retrieveAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "YouTubeAPIKey",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        if let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
```

## Performance Configuration

### Memory Management

```swift
class PerformanceConfiguration {
    // Maximum cached videos
    static let maxCachedVideos = 10
    
    // Clear cache when memory warning
    static func setupMemoryWarningHandler() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            MLMetadataManager.shared.clearAllMetadata()
            print("Cleared metadata cache due to memory warning")
        }
    }
}
```

## Logging Configuration

### Custom Logger

```swift
import os.log

class AppLogger {
    static let subsystem = "com.yourcompany.youtubeplayerapp"
    
    static let player = OSLog(subsystem: subsystem, category: "Player")
    static let metadata = OSLog(subsystem: subsystem, category: "Metadata")
    static let network = OSLog(subsystem: subsystem, category: "Network")
    
    static func log(_ message: String, category: OSLog = .default, type: OSLogType = .info) {
        os_log("%{public}@", log: category, type: type, message)
    }
}

// Usage
AppLogger.log("Loading video", category: .player, type: .info)
```

## Accessibility Configuration

### VoiceOver Support

```swift
extension YouTubePlayerViewController {
    func configureAccessibility() {
        playerView?.isAccessibilityElement = true
        playerView?.accessibilityLabel = "YouTube Video Player"
        playerView?.accessibilityHint = "Double tap to play or pause"
        
        metadataLabel?.isAccessibilityElement = true
        metadataLabel?.accessibilityLabel = "Video Metadata"
    }
}
```

## Localization Configuration

### Localizable.strings (English)

```
"video.loading" = "Loading video...";
"video.error" = "Failed to load video";
"metadata.category" = "Category";
"metadata.tags" = "Tags";
"player.play" = "Play";
"player.pause" = "Pause";
"player.stop" = "Stop";
```

### Usage

```swift
let loadingText = NSLocalizedString("video.loading", comment: "Loading message")
```

---

## Quick Start Configuration

For a minimal working setup:

1. Use the basic `Package.swift` or `Podfile`
2. Add `Info.plist` entries for YouTube domains
3. Create an `AppDelegate` with metadata manager initialization
4. You're ready to use the YouTube player!

For production apps, consider:
- Secure API key storage
- Memory management optimizations
- Comprehensive error handling
- Analytics integration
- Accessibility support
