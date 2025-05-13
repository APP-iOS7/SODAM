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
    dependencies: []
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


let project = Project(
    name: "SODAM",
    targets: [
        sodamApp,
        sodamAppTests
    ]
)
