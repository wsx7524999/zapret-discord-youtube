import Foundation

/// ML Metadata Manager for organizing and enriching video-related data
public class MLMetadataManager {
    
    private var metadataStore: [String: EnrichedMetadata] = [:]
    
    /// Singleton instance
    public static let shared = MLMetadataManager()
    
    private init() {}
    
    // Confidence calculation parameters
    private let baseConfidence: Double = 0.5
    private let tagCountBoost: Double = 0.1
    private let maxTagBoost: Double = 0.3
    private let categoryBoost: Double = 0.1
    private let textLengthBoost: Double = 0.1
    private let minTextLengthForBoost: Int = 50
    
    /// Enrich video metadata with ML-based tags and categories
    /// - Parameter metadata: Base video metadata
    /// - Returns: Enriched metadata with ML-generated tags and calculated confidence
    public func enrichMetadata(_ metadata: VideoMetadata) -> EnrichedMetadata {
        let mlTags = generateMLTags(from: metadata)
        let category = classifyCategory(from: metadata)
        let sentiment = analyzeSentiment(from: metadata.description)
        
        // Calculate confidence based on analysis quality
        let confidence = calculateConfidence(
            tagCount: mlTags.count,
            hasCategory: !category.isEmpty,
            textLength: metadata.description.count + metadata.title.count
        )
        
        let enriched = EnrichedMetadata(
            baseMetadata: metadata,
            mlGeneratedTags: mlTags,
            category: category,
            sentiment: sentiment,
            confidence: confidence
        )
        
        // Store in metadata store
        let key = generateKey(from: metadata)
        metadataStore[key] = enriched
        
        return enriched
    }
    
    /// Calculate confidence score based on analysis quality
    private func calculateConfidence(tagCount: Int, hasCategory: Bool, textLength: Int) -> Double {
        var confidence = baseConfidence
        
        // Increase confidence based on tag generation
        confidence += min(Double(tagCount) * tagCountBoost, maxTagBoost)
        
        // Boost if category was identified
        if hasCategory {
            confidence += categoryBoost
        }
        
        // Boost for sufficient text analysis
        if textLength > minTextLengthForBoost {
            confidence += textLengthBoost
        }
        
        return min(confidence, 1.0)
    }
    
    /// Generate ML-based tags from metadata
    private func generateMLTags(from metadata: VideoMetadata) -> [String] {
        var mlTags: [String] = []
        
        // Analyze title and description for keywords
        let text = "\(metadata.title) \(metadata.description)".lowercased()
        
        // Simple keyword extraction (in production, use actual ML model)
        let keywords = [
            "music": ["music", "song", "audio", "melody"],
            "gaming": ["game", "gaming", "play", "stream"],
            "tutorial": ["tutorial", "how to", "guide", "learn"],
            "entertainment": ["funny", "comedy", "entertainment", "fun"],
            "education": ["education", "learn", "course", "lesson"],
            "technology": ["tech", "technology", "software", "hardware"]
        ]
        
        for (tag, patterns) in keywords {
            if patterns.contains(where: { text.contains($0) }) {
                mlTags.append(tag)
            }
        }
        
        return mlTags
    }
    
    /// Classify video category
    private func classifyCategory(from metadata: VideoMetadata) -> String {
        let title = metadata.title.lowercased()
        
        if title.contains("music") || title.contains("song") {
            return "Music"
        } else if title.contains("game") || title.contains("gaming") {
            return "Gaming"
        } else if title.contains("tutorial") || title.contains("how to") {
            return "Education"
        } else if title.contains("funny") || title.contains("comedy") {
            return "Entertainment"
        }
        
        return "General"
    }
    
    /// Analyze sentiment of text
    private func analyzeSentiment(from text: String) -> String {
        let positiveWords = ["great", "awesome", "excellent", "love", "best"]
        let negativeWords = ["bad", "terrible", "worst", "hate", "awful"]
        
        let lowerText = text.lowercased()
        let positiveCount = positiveWords.filter { lowerText.contains($0) }.count
        let negativeCount = negativeWords.filter { lowerText.contains($0) }.count
        
        if positiveCount > negativeCount {
            return "positive"
        } else if negativeCount > positiveCount {
            return "negative"
        }
        return "neutral"
    }
    
    /// Generate unique key for metadata
    private func generateKey(from metadata: VideoMetadata) -> String {
        return "\(metadata.title)-\(metadata.tags.joined(separator: "-"))"
    }
    
    /// Retrieve enriched metadata
    /// - Parameter key: Metadata key
    /// - Returns: EnrichedMetadata if found
    public func getMetadata(forKey key: String) -> EnrichedMetadata? {
        return metadataStore[key]
    }
    
    /// Get all stored metadata
    /// - Returns: Dictionary of all enriched metadata
    public func getAllMetadata() -> [String: EnrichedMetadata] {
        return metadataStore
    }
    
    /// Clear all stored metadata
    public func clearAllMetadata() {
        metadataStore.removeAll()
    }
}

/// Enriched metadata structure with ML-generated data
public struct EnrichedMetadata: Codable {
    public let baseMetadata: VideoMetadata
    public let mlGeneratedTags: [String]
    public let category: String
    public let sentiment: String
    public let confidence: Double
    
    public init(baseMetadata: VideoMetadata, mlGeneratedTags: [String], category: String, sentiment: String, confidence: Double) {
        self.baseMetadata = baseMetadata
        self.mlGeneratedTags = mlGeneratedTags
        self.category = category
        self.sentiment = sentiment
        self.confidence = confidence
    }
}
