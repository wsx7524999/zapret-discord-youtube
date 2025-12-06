import Foundation
import UIKit
import YouTubePlayer

/// Manager class for handling YouTube video playback
public class YouTubePlayerManager: NSObject {
    
    private var playerView: YouTubePlayerView?
    private var videoMetadata: VideoMetadata?
    
    /// Initialize the YouTube Player Manager
    public override init() {
        super.init()
    }
    
    /// Create and configure a YouTube player view
    /// - Parameter frame: The frame for the player view
    /// - Returns: Configured YouTubePlayerView instance
    public func createPlayerView(frame: CGRect) -> YouTubePlayerView {
        let player = YouTubePlayerView(frame: frame)
        self.playerView = player
        return player
    }
    
    /// Load a YouTube video by ID
    /// - Parameters:
    ///   - videoId: The YouTube video identifier
    ///   - metadata: Optional metadata for the video
    public func loadVideo(videoId: String, metadata: VideoMetadata? = nil) {
        guard let player = playerView else {
            print("Player view not initialized")
            return
        }
        
        self.videoMetadata = metadata
        player.loadVideoID(videoId)
        
        if let meta = metadata {
            print("Loading video: \(videoId)")
            print("Title: \(meta.title)")
            print("Tags: \(meta.tags.joined(separator: ", "))")
        }
    }
    
    /// Play the current video
    public func play() {
        playerView?.play()
    }
    
    /// Pause the current video
    public func pause() {
        playerView?.pause()
    }
    
    /// Stop the current video
    public func stop() {
        playerView?.stop()
    }
    
    /// Get the current video metadata
    /// - Returns: VideoMetadata if available
    public func getMetadata() -> VideoMetadata? {
        return videoMetadata
    }
    
    /// Clear the player and metadata
    public func clear() {
        playerView?.clear()
        videoMetadata = nil
    }
}

/// Structure to hold video metadata
public struct VideoMetadata: Codable {
    public let title: String
    public let description: String
    public let tags: [String]
    public let duration: TimeInterval
    public let uploadDate: Date?
    
    public init(title: String, description: String, tags: [String], duration: TimeInterval, uploadDate: Date? = nil) {
        self.title = title
        self.description = description
        self.tags = tags
        self.duration = duration
        self.uploadDate = uploadDate
    }
}
