//
//  LemonSqueezyLicenseTests.swift
//  LemonSqueezyLicense
//
//  Created by Kevin Hermawan on 10/12/24.
//

import XCTest
@testable import LemonSqueezyLicense

final class LemonSqueezyLicenseTests: XCTestCase {
    var license: LemonSqueezyLicense!
    
    override func setUp() {
        super.setUp()
        
        license = LemonSqueezyLicense()
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    override func tearDown() {
        license = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
        URLProtocolMock.mockData = nil
        URLProtocolMock.mockError = nil
        URLProtocolMock.mockStatusCode = 200
        
        super.tearDown()
    }
    
    func testActivate() async throws {
        let mockResponseString = """
        {
            "activated": true,
            "license_key": {
                "id": 1,
                "status": "active",
                "key": "test-key",
                "activation_limit": 1,
                "activation_usage": 1,
                "created_at": "2021-04-06T14:15:07.000000Z",
                "expires_at": null
            },
            "instance": {
                "id": "test-instance",
                "name": "Test Instance",
                "created_at": "2021-04-06T14:15:07.000000Z"
            },
            "meta": {
                "store_id": 1,
                "order_id": 2,
                "order_item_id": 3,
                "product_id": 4,
                "product_name": "Example Product",
                "variant_id": 5,
                "variant_name": "Default",
                "customer_id": 6,
                "customer_name": "Luke Skywalker",
                "customer_email": "luke@skywalker.com"
            }
        }
        """
        
        URLProtocolMock.mockData = mockResponseString.data(using: .utf8)
        
        let response = try await license.activate(key: "test-key", instanceName: "Test Instance")
        
        XCTAssertTrue(response.activated)
        XCTAssertEqual(response.licenseKey?.key, "test-key")
        XCTAssertEqual(response.instance?.name, "Test Instance")
    }
    
    func testDeactivate() async throws {
        let mockResponseString = """
        {
            "deactivated": true,
            "license_key": {
                "id": 1,
                "status": "inactive",
                "key": "test-key",
                "activation_limit": 1,
                "activation_usage": 0,
                "created_at": "2021-04-06T14:15:07.000000Z",
                "expires_at": null
            },
            "instance": null,
            "meta": {
                "store_id": 1,
                "order_id": 2,
                "order_item_id": 3,
                "product_id": 4,
                "product_name": "Example Product",
                "variant_id": 5,
                "variant_name": "Default",
                "customer_id": 6,
                "customer_name": "Luke Skywalker",
                "customer_email": "luke@skywalker.com"
            }
        }
        """
        
        URLProtocolMock.mockData = mockResponseString.data(using: .utf8)
        
        let response = try await license.deactivate(key: "test-key", instanceId: "test-instance")
        
        XCTAssertTrue(response.deactivated)
        XCTAssertEqual(response.licenseKey?.status, .inactive)
    }
    
    func testValidate() async throws {
        let mockResponseString = """
        {
            "valid": true,
            "license_key": {
                "id": 1,
                "status": "active",
                "key": "test-key",
                "activation_limit": 1,
                "activation_usage": 1,
                "created_at": "2021-04-06T14:15:07.000000Z",
                "expires_at": null
            },
            "instance": {
                "id": "test-instance",
                "name": "Test Instance",
                "created_at": "2021-04-06T14:15:07.000000Z"
            },
            "meta": {
                "store_id": 1,
                "order_id": 2,
                "order_item_id": 3,
                "product_id": 4,
                "product_name": "Example Product",
                "variant_id": 5,
                "variant_name": "Default",
                "customer_id": 6,
                "customer_name": "Luke Skywalker",
                "customer_email": "luke@skywalker.com"
            }
        }
        """
        
        URLProtocolMock.mockData = mockResponseString.data(using: .utf8)
        
        let response = try await license.validate(key: "test-key", instanceId: "test-instance")
        
        XCTAssertTrue(response.valid)
        XCTAssertEqual(response.licenseKey?.status, .active)
    }
    
    func testServerError() async {
        let errorResponse = """
        {
            "error": "Invalid license key"
        }
        """
        
        URLProtocolMock.mockData = errorResponse.data(using: .utf8)
        URLProtocolMock.mockStatusCode = 400
        
        do {
            try await license.activate(key: "invalid-key", instanceName: "Test Instance")
        } catch let error as LemonSqueezyLicenseError {
            switch error {
            case .serverError(let statusCode, let errorMessage):
                XCTAssertEqual(statusCode, 400)
                XCTAssertEqual(errorMessage, "Invalid license key")
            default:
                XCTFail("Unexpected error type")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
