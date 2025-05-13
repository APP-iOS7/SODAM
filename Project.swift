import ProjectDescription


let sodamApp: Target = .target(
    name: "SODAM",
    destinations: .iOS,
    product: .app,
    bundleId: "io.tuist.SODAM",
    infoPlist: .extendingDefault(
        with: [
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
        ]
    ),
    sources: ["SODAM/Sources/**"],
    resources: ["SODAM/Resources/**"],
    dependencies: [
        .target(name: "UICommonExtension")
    ]
)

let sodamAppTests: Target = .target(
    name: "SODAMTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "io.tuist.SODAMTests",
    infoPlist: .default,
    sources: ["SODAM/Tests/**"],
    resources: [],
    dependencies: [.target(name: "SODAM")]
)

// TODO: 커스텀 컬러 사용을 위한 라이브러리
let uiCommonExtension: Target = .target(
    name: "UICommonExtension",
    destinations: .iOS,
    product: .staticLibrary,
    bundleId: "io.tuist.UICommonExtension",
    infoPlist: .default,
    sources: ["SODAM/UICommon/**"],
    dependencies: []
)


let project = Project(
    name: "SODAM",
    targets: [
        sodamApp,
        sodamAppTests,
        uiCommonExtension,
    ]
)
