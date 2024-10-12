//
//  LemonSqueezyLicenseError.swift
//  LemonSqueezyLicense
//
//  Created by Kevin Hermawan on 10/12/24.
//

import Foundation

/// An enum that represents errors that can occur when interacting with the Lemon Squeezy License API.
public enum LemonSqueezyLicenseError: Error {
    /// Indicates that the server response was not in the expected format.
    case badServerResponse
    
    /// Indicates that the server returned an error.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code returned by the server.
    ///   - error: A description of the error, if available.
    case serverError(statusCode: Int, error: String?)
}
