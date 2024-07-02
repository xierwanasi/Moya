// swift-tools-version:5.3

import PackageDescription

let rocketIfNeeded: [Package.Dependency]

#if os(OSX) || os(Linux)
rocketIfNeeded = [
    .package(url: "https://github.com/shibapm/Rocket", .upToNextMajor(from: "1.2.0")) // dev
]
#else
rocketIfNeeded = []
#endif

let package = Package(
    name: "Moya",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "Moya", targets: ["Moya"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")), // dev
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0")), // dev
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.0.0")) // dev
    ] + rocketIfNeeded,
    targets: [
        .target(
            name: "Moya",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ], 
            exclude: [
                "Supporting Files/Info.plist"
            ]
        ),
        .testTarget( // dev
            name: "MoyaTests",  // dev
            dependencies: [ // dev
                "Moya", // dev
                .product(name: "Quick", package: "Quick"), // dev
                .product(name: "Nimble", package: "Nimble"), // dev
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs") // dev
            ] // dev
        ) // dev
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "rocket": [
        "before": [
            "scripts/update_changelog.sh",
            "scripts/update_podspec.sh"
        ],
        "after": [
            "rake create_release\\[\"$VERSION\"\\]",
            "scripts/update_docs_website.sh"
        ]
    ]
]).write()
#endif
