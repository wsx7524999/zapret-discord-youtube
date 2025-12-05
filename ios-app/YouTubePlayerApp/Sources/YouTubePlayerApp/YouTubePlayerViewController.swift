import UIKit
import YouTubePlayer

/// Example View Controller demonstrating YouTube Player and ML Metadata integration
public class YouTubePlayerViewController: UIViewController {
    
    private let playerManager = YouTubePlayerManager()
    private let metadataManager = MLMetadataManager.shared
    
    private var playerView: YouTubePlayerView?
    private var metadataLabel: UILabel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadExampleVideo()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup player view
        let playerFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        let player = playerManager.createPlayerView(frame: playerFrame)
        view.addSubview(player)
        self.playerView = player
        
        // Setup metadata label
        let metadataLabelFrame = CGRect(x: 20, y: 420, width: view.bounds.width - 40, height: 200)
        let label = UILabel(frame: metadataLabelFrame)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        self.metadataLabel = label
        
        // Setup control buttons
        setupControlButtons()
    }
    
    private func setupControlButtons() {
        let buttonWidth: CGFloat = 80
        let buttonHeight: CGFloat = 40
        let buttonY: CGFloat = 640
        
        // Play button
        let playButton = UIButton(frame: CGRect(x: 20, y: buttonY, width: buttonWidth, height: buttonHeight))
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .systemBlue
        playButton.layer.cornerRadius = 8
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        view.addSubview(playButton)
        
        // Pause button
        let pauseButton = UIButton(frame: CGRect(x: 110, y: buttonY, width: buttonWidth, height: buttonHeight))
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.backgroundColor = .systemOrange
        pauseButton.layer.cornerRadius = 8
        pauseButton.addTarget(self, action: #selector(pauseTapped), for: .touchUpInside)
        view.addSubview(pauseButton)
        
        // Stop button
        let stopButton = UIButton(frame: CGRect(x: 200, y: buttonY, width: buttonWidth, height: buttonHeight))
        stopButton.setTitle("Stop", for: .normal)
        stopButton.backgroundColor = .systemRed
        stopButton.layer.cornerRadius = 8
        stopButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        view.addSubview(stopButton)
    }
    
    private func loadExampleVideo() {
        // Create example metadata
        let metadata = VideoMetadata(
            title: "Example YouTube Tutorial Video",
            description: "This is a great tutorial showing how to integrate YouTube player in iOS",
            tags: ["tutorial", "ios", "youtube", "swift"],
            duration: 300,
            uploadDate: Date()
        )
        
        // Enrich metadata with ML
        let enrichedMetadata = metadataManager.enrichMetadata(metadata)
        
        // Display metadata
        displayMetadata(enrichedMetadata)
        
        // Load video (using a sample video ID - replace with actual ID)
        playerManager.loadVideo(videoId: "dQw4w9WgXcQ", metadata: metadata)
    }
    
    private func displayMetadata(_ metadata: EnrichedMetadata) {
        let text = """
        Title: \(metadata.baseMetadata.title)
        
        Category: \(metadata.category)
        Sentiment: \(metadata.sentiment)
        Confidence: \(String(format: "%.2f", metadata.confidence))
        
        Original Tags: \(metadata.baseMetadata.tags.joined(separator: ", "))
        
        ML Generated Tags: \(metadata.mlGeneratedTags.joined(separator: ", "))
        """
        metadataLabel?.text = text
    }
    
    @objc private func playTapped() {
        playerManager.play()
    }
    
    @objc private func pauseTapped() {
        playerManager.pause()
    }
    
    @objc private func stopTapped() {
        playerManager.stop()
    }
}
