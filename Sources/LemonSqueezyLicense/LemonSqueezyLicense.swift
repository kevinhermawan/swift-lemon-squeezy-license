//
//  LemonSqueezyLicense.swift
//  LemonSqueezyLicense
//
//  Created by Kevin Hermawan on 10/12/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A struct that provides methods to interact with the Lemon Squeezy license API.
public struct LemonSqueezyLicense {
    private let baseURL: URL
    
    /// Creates a new instance of ``LemonSqueezyLicense``.
    public init() {
        self.baseURL = URL(string: "https://api.lemonsqueezy.com/v1/licenses")!
    }
    
    /// Activates a license key and receives an instance ID in return.
    ///
    /// - Parameters:
    ///   - key: The license key to activate.
    ///   - instanceName: A label for the new instance to identify it in Lemon Squeezy.
    ///
    /// - Returns: An ``ActivateResponse`` that contains the activation status and related information.
    ///
    /// - Throws: A ``LemonSqueezyLicenseError`` if the request fails or the server returns an error.
    @discardableResult public func activate(key: String, instanceName: String) async throws -> ActivateResponse {
        let request = createRequest(for: "activate", with: ["license_key": key, "instance_name": instanceName])
        
        return try await performRequest(request)
    }
    
    /// Deactivates a license key for a specific instance.
    ///
    /// - Parameters:
    ///   - key: The license key to deactivate.
    ///   - instanceId: The instance ID returned when activating the license key.
    ///
    /// - Returns: A ``DeactivateResponse`` that contains the deactivation status and related information.
    ///
    /// - Throws: A ``LemonSqueezyLicenseError`` if the request fails or the server returns an error.
    @discardableResult public func deactivate(key: String, instanceId: String) async throws -> DeactivateResponse {
        let request = createRequest(for: "deactivate", with: ["license_key": key, "instance_id": instanceId])
        
        return try await performRequest(request)
    }
    
    /// Validates a license key or a specific instance of a license key.
    ///
    /// - Parameters:
    ///   - key: The license key to validate.
    ///   - instanceId: The unique identifier for the instance to validate. If not provided, the method will validate the license key itself, and the response will contain `"instance": nil`.
    ///
    /// - Returns: A ``ValidateResponse`` that contains the validation status and related information.
    ///
    /// - Throws: A ``LemonSqueezyLicenseError`` if the request fails or the server returns an error.
    @discardableResult public func validate(key: String, instanceId: String? = nil) async throws -> ValidateResponse {
        var parameters = ["license_key": key]
        
        if let instanceId {
            parameters["instance_id"] = instanceId
        }
        
        let request = createRequest(for: "validate", with: parameters)
        
        return try await performRequest(request)
    }
}

private extension LemonSqueezyLicense {
    func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LemonSqueezyLicenseError.badServerResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        
        if 200...299 ~= httpResponse.statusCode {
            return try decoder.decode(T.self, from: data)
        } else {
            let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
            
            throw LemonSqueezyLicenseError.serverError(statusCode: httpResponse.statusCode, error: errorResponse?.error)
        }
    }
    
    func createRequest(for endpoint: String, with parameters: [String: String]) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = parameters.map { "\($0)=\($1)" }.joined(separator: "&")
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
}
