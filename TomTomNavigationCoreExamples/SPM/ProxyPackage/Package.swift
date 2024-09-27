// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

//  © 2024 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import PackageDescription

/// The version for all TomTom SDK dependencies.
let sdkVersion: Version = "0.63.0"

/// Dictionary of all dependencies.
/// `key`: package name.
/// `value`: Array of products.
///
/// When using it, make sure you assigned the product to the correct package name.
/// Currently there are 3 packages:
/// * `tomtom-sdk-spm-core`
/// * `tomtom-sdk-spm-navigation`
/// * `tomtom-sdk-spm-offline`
///
/// Add only the packages for which you have products.
let dependencies: [String: [String]] = [
    "tomtom-sdk-spm-core": [
        "TomTomSDKMapDisplay",
        "TomTomSDKRoutePlannerOnline",
        "TomTomSDKRouteReplannerDefault",
    ],
    "tomtom-sdk-spm-navigation": [
        "TomTomSDKNavigationOnline",
        "TomTomSDKNavigationUI",
    ],
]

// MARK: - Internal. You should *NOT* have to change anything from this point onward.

let packageDependencies: [Package.Dependency] = dependencies
    .keys
    .map { package in
        Package.Dependency.package(url: "https://github.com/tomtom-international/\(package).git", exact: sdkVersion)
    }

let targetDependencies: [Target.Dependency] = dependencies
    .flatMap { package, products in
        products.map { product in
            Target.Dependency.product(name: product, package: package)
        }
    }

let package = Package(
    name: "SPMDependencies",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "TomTomSPMDependencies", type: .static, targets: ["TomTomSPMDependencies"]),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(name: "TomTomSPMDependencies", dependencies: targetDependencies),
    ]
)
