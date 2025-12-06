import XCTest
@testable import YouTubePlayerApp

final class MLMetadataManagerTests: XCTestCase {
    
    var metadataManager: MLMetadataManager!
    
    override func setUp() {
        super.setUp()
        metadataManager = MLMetadataManager.shared
        metadataManager.clearAllMetadata()
    }
    
    override func tearDown() {
        metadataManager.clearAllMetadata()
        super.tearDown()
    }
    
    func testMLMetadataManagerSingleton() {
        let instance1 = MLMetadataManager.shared
        let instance2 = MLMetadataManager.shared
        
        XCTAssertTrue(instance1 === instance2, "Should return the same singleton instance")
    }
    
    func testEnrichMetadata() {
        let metadata = VideoMetadata(
            title: "Great Music Tutorial",
            description: "Learn music production with this awesome tutorial",
            tags: ["music", "tutorial"],
            duration: 300
        )
        
        let enriched = metadataManager.enrichMetadata(metadata)
        
        XCTAssertNotNil(enriched)
        XCTAssertEqual(enriched.baseMetadata.title, metadata.title)
        XCTAssertGreaterThan(enriched.mlGeneratedTags.count, 0)
        XCTAssertFalse(enriched.category.isEmpty)
        XCTAssertFalse(enriched.sentiment.isEmpty)
        XCTAssertGreaterThan(enriched.confidence, 0.0)
    }
    
    func testMLTagGeneration() {
        let musicMetadata = VideoMetadata(
            title: "Amazing Song Performance",
            description: "Watch this beautiful music performance",
            tags: ["performance"],
            duration: 200
        )
        
        let enriched = metadataManager.enrichMetadata(musicMetadata)
        
        XCTAssertTrue(enriched.mlGeneratedTags.contains("music"), "Should detect music tag")
    }
    
    func testCategoryClassification() {
        let tutorialMetadata = VideoMetadata(
            title: "How to Build iOS Apps",
            description: "Complete tutorial for beginners",
            tags: ["ios", "tutorial"],
            duration: 600
        )
        
        let enriched = metadataManager.enrichMetadata(tutorialMetadata)
        
        XCTAssertEqual(enriched.category, "Education")
    }
    
    func testSentimentAnalysis() {
        let positiveMetadata = VideoMetadata(
            title: "Amazing Video",
            description: "This is a great and excellent video",
            tags: ["awesome"],
            duration: 100
        )
        
        let enriched = metadataManager.enrichMetadata(positiveMetadata)
        
        XCTAssertEqual(enriched.sentiment, "positive")
    }
    
    func testMetadataStorage() {
        let metadata = VideoMetadata(
            title: "Test Video",
            description: "Test description",
            tags: ["test"],
            duration: 150
        )
        
        let enriched = metadataManager.enrichMetadata(metadata)
        
        let allMetadata = metadataManager.getAllMetadata()
        XCTAssertGreaterThan(allMetadata.count, 0)
    }
    
    func testClearAllMetadata() {
        let metadata = VideoMetadata(
            title: "Test",
            description: "Test",
            tags: ["test"],
            duration: 100
        )
        
        _ = metadataManager.enrichMetadata(metadata)
        
        var allMetadata = metadataManager.getAllMetadata()
        XCTAssertGreaterThan(allMetadata.count, 0)
        
        metadataManager.clearAllMetadata()
        
        allMetadata = metadataManager.getAllMetadata()
        XCTAssertEqual(allMetadata.count, 0)
    }
    
    func testEnrichedMetadataProperties() {
        let baseMetadata = VideoMetadata(
            title: "Gaming Stream",
            description: "Live gaming stream",
            tags: ["gaming", "stream"],
            duration: 3600
        )
        
        let enriched = metadataManager.enrichMetadata(baseMetadata)
        
        XCTAssertEqual(enriched.baseMetadata.title, "Gaming Stream")
        XCTAssertEqual(enriched.category, "Gaming")
        XCTAssertTrue(enriched.mlGeneratedTags.contains("gaming"))
    }
}

final class EnrichedMetadataTests: XCTestCase {
    
    func testEnrichedMetadataEncoding() throws {
        let baseMetadata = VideoMetadata(
            title: "Test",
            description: "Test description",
            tags: ["test"],
            duration: 100
        )
        
        let enriched = EnrichedMetadata(
            baseMetadata: baseMetadata,
            mlGeneratedTags: ["ml-tag1", "ml-tag2"],
            category: "Test",
            sentiment: "neutral",
            confidence: 0.85
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(enriched)
        
        XCTAssertNotNil(data)
        XCTAssertGreaterThan(data.count, 0)
    }
    
    func testEnrichedMetadataDecoding() throws {
        let baseMetadata = VideoMetadata(
            title: "Test",
            description: "Test description",
            tags: ["test"],
            duration: 100
        )
        
        let enriched = EnrichedMetadata(
            baseMetadata: baseMetadata,
            mlGeneratedTags: ["ml-tag1"],
            category: "Test",
            sentiment: "positive",
            confidence: 0.90
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(enriched)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(EnrichedMetadata.self, from: data)
        
        XCTAssertEqual(decoded.baseMetadata.title, enriched.baseMetadata.title)
        XCTAssertEqual(decoded.mlGeneratedTags, enriched.mlGeneratedTags)
        XCTAssertEqual(decoded.category, enriched.category)
        XCTAssertEqual(decoded.sentiment, enriched.sentiment)
        XCTAssertEqual(decoded.confidence, enriched.confidence)
    }
}
