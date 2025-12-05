# Example Usage Scenarios

This document provides practical examples for common use cases when integrating YouTube player and ML metadata functionality.

## Table of Contents

1. [Basic Video Playback](#basic-video-playback)
2. [Video with Metadata](#video-with-metadata)
3. [Video List Application](#video-list-application)
4. [Playlist Manager](#playlist-manager)
5. [Search and Filter](#search-and-filter)
6. [Offline Support](#offline-support)
7. [Analytics Integration](#analytics-integration)

## Basic Video Playback

### Single Video Player

```swift
import UIKit
import YouTubePlayerApp

class SimpleVideoViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupPlayer()
        loadVideo()
    }
    
    func setupPlayer() {
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
    }
    
    func loadVideo() {
        playerManager.loadVideo(videoId: "dQw4w9WgXcQ")
        playerManager.play()
    }
}
```

## Video with Metadata

### Enhanced Video Player

```swift
import UIKit
import YouTubePlayerApp

class MetadataVideoViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let metadataManager = MLMetadataManager.shared
    
    var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadVideoWithMetadata()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Player
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Info label
        infoLabel = UILabel(frame: CGRect(x: 20, y: 420, width: view.bounds.width - 40, height: 150))
        infoLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 14)
        view.addSubview(infoLabel)
    }
    
    func loadVideoWithMetadata() {
        // Create metadata
        let metadata = VideoMetadata(
            title: "Swift Programming Tutorial",
            description: "Learn Swift programming with this comprehensive tutorial",
            tags: ["swift", "programming", "ios", "tutorial"],
            duration: 1200
        )
        
        // Enrich with ML
        let enriched = metadataManager.enrichMetadata(metadata)
        
        // Display info
        infoLabel.text = """
        📺 \(enriched.baseMetadata.title)
        
        🏷️ Category: \(enriched.category)
        😊 Sentiment: \(enriched.sentiment)
        🤖 ML Tags: \(enriched.mlGeneratedTags.joined(separator: ", "))
        ⏱️ Duration: \(Int(enriched.baseMetadata.duration))s
        """
        
        // Load video
        playerManager.loadVideo(videoId: "YOUR_VIDEO_ID", metadata: metadata)
    }
}
```

## Video List Application

### Video Library with TableView

```swift
import UIKit
import YouTubePlayerApp

struct Video {
    let id: String
    let metadata: VideoMetadata
}

class VideoLibraryViewController: UITableViewController {
    let metadataManager = MLMetadataManager.shared
    var videos: [Video] = []
    var enrichedMetadata: [String: EnrichedMetadata] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Library"
        tableView.register(VideoCell.self, forCellReuseIdentifier: "VideoCell")
        loadVideos()
    }
    
    func loadVideos() {
        videos = [
            Video(id: "video1", metadata: VideoMetadata(
                title: "iOS Development Basics",
                description: "Learn the basics of iOS development",
                tags: ["ios", "development", "tutorial"],
                duration: 900
            )),
            Video(id: "video2", metadata: VideoMetadata(
                title: "Swift Language Tour",
                description: "Complete tour of Swift programming language",
                tags: ["swift", "programming", "tutorial"],
                duration: 1800
            )),
            Video(id: "video3", metadata: VideoMetadata(
                title: "Music Production Tips",
                description: "Professional music production techniques",
                tags: ["music", "production", "audio"],
                duration: 600
            ))
        ]
        
        // Enrich all metadata
        for video in videos {
            let enriched = metadataManager.enrichMetadata(video.metadata)
            enrichedMetadata[video.id] = enriched
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        let video = videos[indexPath.row]
        
        if let enriched = enrichedMetadata[video.id] {
            cell.configure(with: enriched)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        showVideoPlayer(video: video)
    }
    
    func showVideoPlayer(video: Video) {
        let playerVC = VideoPlayerViewController()
        playerVC.videoId = video.id
        playerVC.metadata = video.metadata
        navigationController?.pushViewController(playerVC, animated: true)
    }
}

class VideoCell: UITableViewCell {
    func configure(with metadata: EnrichedMetadata) {
        textLabel?.text = metadata.baseMetadata.title
        detailTextLabel?.text = "\(metadata.category) • \(metadata.mlGeneratedTags.prefix(2).joined(separator: ", "))"
    }
}

class VideoPlayerViewController: UIViewController {
    var videoId: String?
    var metadata: VideoMetadata?
    let playerManager = YouTubePlayerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let videoId = videoId, let metadata = metadata {
            setupPlayer()
            playerManager.loadVideo(videoId: videoId, metadata: metadata)
            playerManager.play()
        }
    }
    
    func setupPlayer() {
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
    }
}
```

## Playlist Manager

### Playlist with Auto-play

```swift
import UIKit
import YouTubePlayerApp

class PlaylistViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let metadataManager = MLMetadataManager.shared
    
    var playlist: [(id: String, metadata: VideoMetadata)] = []
    var currentIndex = 0
    
    var playlistLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPlaylist()
        playCurrentVideo()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Player
        let playerView = playerManager.createPlayerView(
            frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        )
        view.addSubview(playerView)
        
        // Playlist info
        playlistLabel = UILabel(frame: CGRect(x: 20, y: 420, width: view.bounds.width - 40, height: 50))
        playlistLabel.numberOfLines = 2
        playlistLabel.textAlignment = .center
        view.addSubview(playlistLabel)
        
        // Next button
        let nextButton = UIButton(frame: CGRect(x: 20, y: 500, width: view.bounds.width - 40, height: 44))
        nextButton.setTitle("Next Video", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 8
        nextButton.addTarget(self, action: #selector(nextVideo), for: .touchUpInside)
        view.addSubview(nextButton)
    }
    
    func loadPlaylist() {
        playlist = [
            ("video1", VideoMetadata(title: "Video 1", description: "First video", tags: ["playlist"], duration: 300)),
            ("video2", VideoMetadata(title: "Video 2", description: "Second video", tags: ["playlist"], duration: 400)),
            ("video3", VideoMetadata(title: "Video 3", description: "Third video", tags: ["playlist"], duration: 350))
        ]
    }
    
    func playCurrentVideo() {
        guard currentIndex < playlist.count else {
            playlistLabel.text = "Playlist Complete!"
            return
        }
        
        let (videoId, metadata) = playlist[currentIndex]
        let enriched = metadataManager.enrichMetadata(metadata)
        
        playlistLabel.text = "Playing \(currentIndex + 1)/\(playlist.count): \(metadata.title)"
        playerManager.loadVideo(videoId: videoId, metadata: metadata)
        playerManager.play()
    }
    
    @objc func nextVideo() {
        currentIndex += 1
        playCurrentVideo()
    }
}
```

## Search and Filter

### Video Search with ML Filtering

```swift
import UIKit
import YouTubePlayerApp

class VideoSearchViewController: UITableViewController, UISearchBarDelegate {
    let metadataManager = MLMetadataManager.shared
    
    var allVideos: [(id: String, enriched: EnrichedMetadata)] = []
    var filteredVideos: [(id: String, enriched: EnrichedMetadata)] = []
    
    let searchBar = UISearchBar()
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Videos"
        
        setupSearchBar()
        loadVideos()
        filteredVideos = allVideos
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search videos..."
        tableView.tableHeaderView = searchBar
    }
    
    func loadVideos() {
        let videoData = [
            ("v1", VideoMetadata(title: "Swift Tutorial", description: "Learn Swift", tags: ["swift"], duration: 600)),
            ("v2", VideoMetadata(title: "Music Production", description: "Make music", tags: ["music"], duration: 800)),
            ("v3", VideoMetadata(title: "Gaming Stream", description: "Live gaming", tags: ["gaming"], duration: 3600))
        ]
        
        allVideos = videoData.map { (id, metadata) in
            let enriched = metadataManager.enrichMetadata(metadata)
            return (id, enriched)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterVideos(query: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func filterVideos(query: String) {
        if query.isEmpty {
            filteredVideos = allVideos
        } else {
            filteredVideos = allVideos.filter { (_, enriched) in
                let title = enriched.baseMetadata.title.lowercased()
                let category = enriched.category.lowercased()
                let tags = enriched.mlGeneratedTags.joined(separator: " ").lowercased()
                let searchQuery = query.lowercased()
                
                return title.contains(searchQuery) || 
                       category.contains(searchQuery) || 
                       tags.contains(searchQuery)
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredVideos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let (_, enriched) = filteredVideos[indexPath.row]
        
        cell.textLabel?.text = enriched.baseMetadata.title
        cell.detailTextLabel?.text = "Category: \(enriched.category)"
        
        return cell
    }
}
```

## Offline Support

### Cache and Offline Metadata

```swift
import Foundation
import YouTubePlayerApp

class OfflineVideoManager {
    static let shared = OfflineVideoManager()
    private let fileManager = FileManager.default
    private var cacheDirectory: URL
    
    init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("VideoMetadata")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func saveMetadata(_ metadata: EnrichedMetadata, forVideoId videoId: String) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(metadata) else { return }
        
        let fileURL = cacheDirectory.appendingPathComponent("\(videoId).json")
        try? data.write(to: fileURL)
    }
    
    func loadMetadata(forVideoId videoId: String) -> EnrichedMetadata? {
        let fileURL = cacheDirectory.appendingPathComponent("\(videoId).json")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(EnrichedMetadata.self, from: data)
    }
    
    func getAllCachedVideos() -> [String] {
        guard let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        
        return files.map { $0.deletingPathExtension().lastPathComponent }
    }
    
    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

// Usage
class OfflineViewController: UIViewController {
    let offlineManager = OfflineVideoManager.shared
    let metadataManager = MLMetadataManager.shared
    
    func saveVideoForOffline(videoId: String, metadata: VideoMetadata) {
        let enriched = metadataManager.enrichMetadata(metadata)
        offlineManager.saveMetadata(enriched, forVideoId: videoId)
        print("Saved metadata for offline use")
    }
    
    func loadOfflineVideo(videoId: String) {
        if let metadata = offlineManager.loadMetadata(forVideoId: videoId) {
            print("Loaded offline metadata: \(metadata.baseMetadata.title)")
            // Use the metadata
        }
    }
}
```

## Analytics Integration

### Track Video Interactions

```swift
import Foundation
import YouTubePlayerApp

class VideoAnalytics {
    static let shared = VideoAnalytics()
    
    struct VideoEvent {
        let videoId: String
        let eventType: EventType
        let timestamp: Date
        let metadata: EnrichedMetadata?
        
        enum EventType: String {
            case play, pause, stop, complete
            case skip, seekForward, seekBackward
        }
    }
    
    private var events: [VideoEvent] = []
    
    func trackEvent(videoId: String, type: VideoEvent.EventType, metadata: EnrichedMetadata? = nil) {
        let event = VideoEvent(
            videoId: videoId,
            eventType: type,
            timestamp: Date(),
            metadata: metadata
        )
        events.append(event)
        
        // Send to analytics service
        sendToAnalytics(event)
    }
    
    private func sendToAnalytics(_ event: VideoEvent) {
        print("Analytics: \(event.eventType.rawValue) - \(event.videoId)")
        // Implement your analytics integration here
    }
    
    func getVideoStats(videoId: String) -> [VideoEvent.EventType: Int] {
        let videoEvents = events.filter { $0.videoId == videoId }
        var stats: [VideoEvent.EventType: Int] = [:]
        
        for event in videoEvents {
            stats[event.eventType, default: 0] += 1
        }
        
        return stats
    }
}

// Usage in ViewController
class AnalyticsVideoViewController: UIViewController {
    let playerManager = YouTubePlayerManager()
    let analytics = VideoAnalytics.shared
    var currentVideoId: String?
    
    func loadAndTrackVideo(videoId: String, metadata: VideoMetadata) {
        currentVideoId = videoId
        let enriched = MLMetadataManager.shared.enrichMetadata(metadata)
        
        playerManager.loadVideo(videoId: videoId, metadata: metadata)
        analytics.trackEvent(videoId: videoId, type: .play, metadata: enriched)
    }
    
    @objc func pauseVideo() {
        playerManager.pause()
        if let videoId = currentVideoId {
            analytics.trackEvent(videoId: videoId, type: .pause)
        }
    }
}
```

## Summary

These examples demonstrate:

✅ Basic video playback  
✅ Metadata enrichment with ML  
✅ Video library management  
✅ Playlist functionality  
✅ Search and filtering  
✅ Offline support  
✅ Analytics tracking  

Each example can be customized and extended based on your specific requirements.
