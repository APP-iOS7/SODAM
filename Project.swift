import ProjectDescription

let bundleId: String = "io.tuist.SODAM" // 번들 ID
let minimumVersionIOS: String = "17.0" // IOS 최소 버젼
let appVersion: Plist.Value = "1.0.0" // 앱 버젼 정보

let sodamApp: Target = .target(
    name: "SODAM",
    destinations: [.iPhone],
    product: .app,
    bundleId: bundleId,
    deploymentTargets: .iOS(minimumVersionIOS), // IOS 최소 버젼
    infoPlist: .extendingDefault(
        with: [
            "UILaunchScreen": [
                "UIColorName": "",
                "UIImageName": "",
            ],
            "UIBackgroundModes": [
                "audio" // 오디오 백그라운드 모드만 추가
            ],
            // 250513 1709 KTG
            // 앱 사용 중일 때 위치 권한
            "NSLocationWhenInUseUsageDescription": "앱 사용 중 위치 권한.",
            // 앱이 백그라운드일 때 위치 권한
            "NSLocationAlwaysAndWhenInUseUsageDescription": "백그라운드에서 위치 권한.",
            "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
            "TOUR_API_KEY": "$(TOUR_API_KEY)",
            "GEOCODER_API_KEY": "$(GEOCODER_API_KEY)",
            "NSAppTransportSecurity": [
                "NSExceptionDomains": [
                    "apis.data.go.kr": [
                        "NSExceptionAllowsInsecureHTTPLoads": true,
                        "NSIncludesSubdomains": true,
                        "NSExceptionRequiresForwardSecrecy": false
                    ]
                ]
            ],
            "CFBundleShortVersionString": appVersion,  // version
            "CFBundleVersion": "1"                  // build number
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
    destinations: [.iPhone],
    product: .unitTests,
    bundleId: "\(bundleId).SODAMTests",
    deploymentTargets: .iOS(minimumVersionIOS), // IOS 최소 버젼
    infoPlist: .default,
    sources: ["SODAM/Tests/**"],
    resources: [],
    dependencies: [.target(name: "SODAM")]
)

// TODO: 커스텀 컬러 사용을 위한 라이브러리
let uiCommonExtension: Target = .target(
    name: "UICommonExtension",
    destinations: [.iPhone],
    product: .staticLibrary,
    bundleId: "\(bundleId).UICommonExtension",
    deploymentTargets: .iOS(minimumVersionIOS), // IOS 최소 버젼
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
