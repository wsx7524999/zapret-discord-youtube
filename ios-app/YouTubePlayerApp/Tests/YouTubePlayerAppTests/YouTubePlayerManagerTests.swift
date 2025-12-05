import XCTest
@testable import YouTubePlayerApp

final class YouTubePlayerManagerTests: XCTestCase {
    
    var playerManager: YouTubePlayerManager!
    
    override func setUp() {
        super.setUp()
        playerManager = YouTubePlayerManager()
    }
    
    override func tearDown() {
        playerManager = nil
        super.tearDown()
    }
    
    func testPlayerManagerInitialization() {
        XCTAssertNotNil(playerManager, "Player manager should be initialized")
    }
    
    func testCreatePlayerView() {
        let frame = CGRect(x: 0, y: 0, width: 320, height: 240)
        let playerView = playerManager.createPlayerView(frame: frame)
        
        XCTAssertNotNil(playerView, "Player view should be created")
        XCTAssertEqual(playerView.frame, frame, "Player view frame should match")
    }
    
    func testLoadVideoWithMetadata() {
        let metadata = VideoMetadata(
            title: "Test Video",
            description: "This is a test video",
            tags: ["test", "ios"],
            duration: 120
        )
        
        let frame = CGRect(x: 0, y: 0, width: 320, height: 240)
        _ = playerManager.createPlayerView(frame: frame)
        
        playerManager.loadVideo(videoId: "test123", metadata: metadata)
        
        let retrievedMetadata = playerManager.getMetadata()
        XCTAssertNotNil(retrievedMetadata, "Metadata should be stored")
        XCTAssertEqual(retrievedMetadata?.title, "Test Video")
    }
    
    func testClearPlayer() {
        let metadata = VideoMetadata(
            title: "Test Video",
            description: "Test",
            tags: ["test"],
            duration: 100
        )
        
        let frame = CGRect(x: 0, y: 0, width: 320, height: 240)
        _ = playerManager.createPlayerView(frame: frame)
        playerManager.loadVideo(videoId: "test123", metadata: metadata)
        
        playerManager.clear()
        
        let retrievedMetadata = playerManager.getMetadata()
        XCTAssertNil(retrievedMetadata, "Metadata should be cleared")
    }
}

final class VideoMetadataTests: XCTestCase {
    
    func testVideoMetadataCreation() {
        let metadata = VideoMetadata(
            title: "Sample Video",
            description: "Sample description",
            tags: ["sample", "test"],
            duration: 300,
            uploadDate: Date()
        )
        
        XCTAssertEqual(metadata.title, "Sample Video")
        XCTAssertEqual(metadata.description, "Sample description")
        XCTAssertEqual(metadata.tags.count, 2)
        XCTAssertEqual(metadata.duration, 300)
        XCTAssertNotNil(metadata.uploadDate)
    }
    
    func testVideoMetadataEncoding() throws {
        let metadata = VideoMetadata(
            title: "Test",
            description: "Description",
            tags: ["tag1"],
            duration: 100
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(metadata)
        
        XCTAssertNotNil(data)
        XCTAssertGreaterThan(data.count, 0)
    }
    
    func testVideoMetadataDecoding() throws {
        let metadata = VideoMetadata(
            title: "Test",
            description: "Description",
            tags: ["tag1"],
            duration: 100
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(metadata)
        
        let decoder = JSONDecoder()
        let decodedMetadata = try decoder.decode(VideoMetadata.self, from: data)
        
        XCTAssertEqual(decodedMetadata.title, metadata.title)
        XCTAssertEqual(decodedMetadata.description, metadata.description)
        XCTAssertEqual(decodedMetadata.tags, metadata.tags)
        XCTAssertEqual(decodedMetadata.duration, metadata.duration)
    }
}
