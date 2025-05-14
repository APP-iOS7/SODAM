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
            "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
            "TOUR_API_KEY": "$(TOUR_API_KEY)",
            "GEOCODER_API_KEY": "$(GEOCODER_API_KEY)"
        ]
    ),
    sources: ["SODAM/Sources/**"],
    resources: ["SODAM/Resources/**"],
    dependencies: [
        .target(name: "UICommonExtension"),
        .external(name: "KakaoMapsSDK-SPM")
    ],
    settings: .settings(
        base: [:],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: .relativeToRoot("Configurations/config.xcconfig")
            ),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("Configurations/config.xcconfig")
            )
        ]
    )
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
