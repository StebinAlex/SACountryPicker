// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SACountryPicker",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SACountryPicker",
            targets: ["SACountryPicker"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SACountryPicker",
            dependencies: [],
            resources: [
                .process("Resources/cancel.png"),.process("Resources/flag_indices.json"),.process("Resources/phone_country_code.json"),.process("Resources/flags.png"),.process("Resources/flags_missing.png"),.process("Resources/flags_missing@2x.png"),.process("Resources/flags@2x.png")
            ]),
        .testTarget(
            name: "SACountryPickerTests",
            dependencies: ["SACountryPicker"]),
    ]
)
