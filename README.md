# LemonSqueezyLicense

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkevinhermawan%2Fswift-lemon-squeezy-license%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/kevinhermawan/swift-lemon-squeezy-license) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkevinhermawan%2Fswift-lemon-squeezy-license%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kevinhermawan/swift-lemon-squeezy-license)

A simple and intuitive way for interacting with the Lemon Squeezy License API in Swift.

## Overview

The `LemonSqueezyLicense` package provides a simple and intuitive way to integrate [Lemon Squeezy's licensing system](https://docs.lemonsqueezy.com/help/licensing/license-api) into your Swift applications. It allows you to perform key operations such as activating, deactivating, and validating license keys.

## Installation

You can add `LemonSqueezyLicense` as a dependency to your project using Swift Package Manager by adding it to the dependencies value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/kevinhermawan/swift-lemon-squeezy-license.git", .upToNextMajor(from: "1.0.0"))
],
targets: [
    .target(
        /// ...
        dependencies: [.product(name: "LemonSqueezyLicense", package: "swift-lemon-squeezy-license")])
]
```

Alternatively, in Xcode:

1. Open your project in Xcode.
2. Click on `File` -> `Swift Packages` -> `Add Package Dependency...`
3. Enter the repository URL: `https://github.com/kevinhermawan/swift-lemon-squeezy-license.git`
4. Choose the version you want to add. You probably want to add the latest version.
5. Click `Add Package`.

## Documentation

You can find the documentation here: [https://kevinhermawan.github.io/swift-lemon-squeezy-license/documentation/lemonsqueezylicense](https://kevinhermawan.github.io/swift-lemon-squeezy-license/documentation/lemonsqueezylicense)

## Usage

### Initialization

To start using the `LemonSqueezyLicense` package, first import it and create an instance of the `LemonSqueezyLicense` struct:

```swift
import LemonSqueezyLicense

let license = LemonSqueezyLicense()
```

### Activating a License

To activate a license key for a new instance of your application:

```swift
do {
    let response = try await license.activate(key: "your-license-key", instanceName: "User's Mac")

    if response.activated {
        print("License activated successfully!")
        print("Instance ID: \(response.instance?.id ?? "N/A")")
    } else {
        print("License activation failed: \(response.licenseKey?.status ?? "Unknown status")")
    }
} catch {
    print("An error occurred: \(error)")
}
```

### Validating a License

To validate an existing license key:

```swift
do {
    let response = try await license.validate(key: "your-license-key", instanceId: "instance-id")

    if response.valid {
        print("License is valid!")
    } else {
        print("License is not valid: \(response.licenseKey?.status ?? "Unknown status")")
    }
} catch {
    print("An error occurred: \(error)")
}
```

### Deactivating a License

To deactivate a license for a specific instance:

```swift
do {
    let response = try await license.deactivate(key: "your-license-key", instanceId: "instance-id")

    if response.deactivated {
        print("License deactivated successfully!")
    } else {
        print("License deactivation failed: \(response.licenseKey?.status ?? "Unknown status")")
    }
} catch {
    print("An error occurred: \(error)")
}
```

### Error Handling

The package uses `LemonSqueezyLicenseError` to represent specific errors that may occur during API interactions. You can catch and handle these errors as follows:

```swift
do {
    let response = try await license.activate(key: "your-license-key", instanceName: "User's Mac")
    // Handle successful response
} catch let error as LemonSqueezyLicenseError {
    switch error {
    case .badServerResponse:
        print("Received an invalid response from the server")
    case .serverError(let statusCode, let errorMessage):
        print("Server error (status \(statusCode)): \(errorMessage ?? "No error message provided")")
    }
} catch {
    print("An unexpected error occurred: \(error)")
}
```

## Donations

If you find `LemonSqueezyLicense` helpful and would like to support its development, consider making a donation. Your contribution helps maintain the project and develop new features.

- [GitHub Sponsors](https://github.com/sponsors/kevinhermawan)
- [Buy Me a Coffee](https://buymeacoffee.com/kevinhermawan)

Your support is greatly appreciated!

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.

## License

This repository is available under the [Apache License 2.0](LICENSE).
