# ``LemonSqueezyLicense``

A simple and intuitive way for interacting with the Lemon Squeezy License API in Swift.

## Overview

The ``LemonSqueezyLicense`` package provides a simple and intuitive way to integrate [Lemon Squeezy's licensing system](https://docs.lemonsqueezy.com/help/licensing/license-api) into your Swift applications. It allows you to perform key operations such as activating, deactivating, and validating license keys.

## Usage

### Initialization

To start using the ``LemonSqueezyLicense`` package, first import it and create an instance of the ``LemonSqueezyLicense`` struct:

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

The package uses ``LemonSqueezyLicenseError`` to represent specific errors that may occur during API interactions. You can catch and handle these errors as follows:

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
