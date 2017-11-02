// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "BeaverScript",
    dependencies: [
	    .package(url: "https://github.com/Beaver/BeaverCodeGen.git", from: "0.0.1"),
	    .package(url: "https://github.com/kylef/Commander.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "BeaverScript",
            dependencies: ["BeaverCodeGen", "Commander"])
    ]
)
