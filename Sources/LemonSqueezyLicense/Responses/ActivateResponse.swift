//
//  ActivateResponse.swift
//  LemonSqueezyLicense
//
//  Created by Kevin Hermawan on 10/12/24.
//

import Foundation

/// A struct that represents the response from a license activation request.
public struct ActivateResponse: Decodable {
    /// A Boolean value that indicates whether the activation was successful.
    public let activated: Bool
    
    /// An object that contains information about the activated license key.
    public let licenseKey: LicenseKey?
    
    /// An object that contains information about the activated instance.
    public let instance: Instance?
    
    /// An object that contains metadata about the activation.
    public let meta: Meta?
    
    /// A struct that represents a license key.
    public struct LicenseKey: Decodable {
        /// The unique identifier for the license key.
        public let id: Int
        
        /// The current status of the license key.
        public let status: Status
        
        /// The actual license key string.
        public let key: String
        
        /// The maximum number of times this license key can be activated.
        public let activationLimit: Int
        
        /// The number of times this license key has been activated.
        public let activationUsage: Int
        
        /// The date when the license key was created.
        public let createdAt: Date
        
        /// The date when the license key expires, if applicable.
        public let expiresAt: Date?
        
        /// An enum that represents the possible statuses of a license key.
        public enum Status: String, Decodable, CaseIterable {
            /// The license key is active and can be used.
            case active
            
            /// The license key is inactive and cannot be used.
            case inactive
            
            /// The license key has expired and can no longer be used.
            case expired
            
            /// The license key has been disabled and cannot be used.
            case disabled
        }
        
        private enum CodingKeys: String, CodingKey {
            case id, status, key
            case activationLimit = "activation_limit"
            case activationUsage = "activation_usage"
            case createdAt = "created_at"
            case expiresAt = "expires_at"
        }
    }
    
    /// A struct that represents an instance of an activated license.
    public struct Instance: Decodable {
        /// The unique identifier for the instance.
        public let id: String
        
        /// The name of the instance.
        public let name: String
        
        /// The date when the instance was created.
        public let createdAt: Date
        
        private enum CodingKeys: String, CodingKey {
            case id, name
            case createdAt = "created_at"
        }
    }
    
    /// A struct that contains metadata about the license activation.
    public struct Meta: Decodable {
        /// The unique identifier of the store.
        public let storeId: Int
        
        /// The unique identifier of the order.
        public let orderId: Int
        
        /// The unique identifier of the order item.
        public let orderItemId: Int
        
        /// The unique identifier of the product.
        public let productId: Int
        
        /// The name of the product.
        public let productName: String
        
        /// The unique identifier of the variant.
        public let variantId: Int
        
        /// The name of the variant.
        public let variantName: String
        
        /// The unique identifier of the customer.
        public let customerId: Int
        
        /// The name of the customer.
        public let customerName: String
        
        /// The email address of the customer.
        public let customerEmail: String
        
        private enum CodingKeys: String, CodingKey {
            case storeId = "store_id"
            case orderId = "order_id"
            case orderItemId = "order_item_id"
            case productId = "product_id"
            case productName = "product_name"
            case variantId = "variant_id"
            case variantName = "variant_name"
            case customerId = "customer_id"
            case customerName = "customer_name"
            case customerEmail = "customer_email"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case activated
        case licenseKey = "license_key"
        case instance, meta
    }
}
