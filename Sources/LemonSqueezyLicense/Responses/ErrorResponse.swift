//
//  ErrorResponse.swift
//  LemonSqueezyLicense
//
//  Created by Kevin Hermawan on 10/12/24.
//

import Foundation

/// A struct that represents an error response from the Lemon Squeezy API.
public struct ErrorResponse: Decodable {
    /// A string that describes the error that occurred.
    public let error: String
}
