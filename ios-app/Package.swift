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
        // YouTube iOS Player Helper - using minor version constraint for patch updates
        .package(url: "https://github.com/youtube/youtube-ios-player-helper.git", .upToNextMinor(from: "1.0.4")),
    ],
    targets: [
        .target(
            name: "YouTubePlayerApp",
            dependencies: [
                .product(name: "YouTubePlayer", package: "youtube-ios-player-helper")
            ],
            path: "YouTubePlayerApp/Sources"
        ),
        .testTarget(
            name: "YouTubePlayerAppTests",
            dependencies: ["YouTubePlayerApp"],
            path: "YouTubePlayerApp/Tests"
        ),
    ]
)
