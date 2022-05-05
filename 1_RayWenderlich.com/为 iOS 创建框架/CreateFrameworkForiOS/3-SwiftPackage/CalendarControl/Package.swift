// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "CalendarControl",
    // 平台
    platforms: [
        .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
    ],
    // package 提供的产品，可以是：
    // library - 可以导入其他 Swift 项目的代码；
    // executable - 可以由操作系统运行的代码；
    products: [
        .library(name: "CalendarControl", targets: ["CalendarControl"])
    ],
    // 目标，目标是独立构建的代码模块。在这里为 XCFramework 添加路径
    targets: [
        .binaryTarget(name: "CalendarControl", path: "./Sources/CalendarControl.xcframework")
    ]
)
