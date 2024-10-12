//
//  AppView.swift
//  Playground
//
//  Created by Kevin Hermawan on 10/12/24.
//

import SwiftUI
import LemonSqueezyLicense

struct AppView: View {
    private let license = LemonSqueezyLicense()
    
    @AppStorage("licenseKey") private var licenseKey: String = ""
    @AppStorage("instanceId") private var instanceId: String = ""
    
    @State private var isLoading: Bool = false
    @State private var status: String? = nil
    @State private var customerName: String? = nil
    @State private var customerEmail: String? = nil
    @State private var errorMessage: String? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("License Key") {
                        TextField("License Key", text: $licenseKey)
                        
                        Text("Instance ID")
                            .badge(Text(instanceId))
                    }
                    
                    if let errorMessage {
                        Section("Error Message") {
                            Text(errorMessage)
                        }
                    }
                    
                    if let status, let customerName, let customerEmail {
                        Section("Information") {
                            Text("Status")
                                .badge(Text(status))
                            
                            Text("Customer Name")
                                .badge(Text(customerName))
                            
                            Text("Customer Email")
                                .badge(Text(customerEmail))
                        }
                    }
                    
                    Section("Actions") {
                        Button("Activate", action: activate)
                        Button("Deactivate", action: deactivate)
                        Button("Validate", action: validate)
                    }
                }
            }
            .navigationTitle("Playground")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func activate() {
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            defer { self.isLoading = false }
            
            do {
                let response = try await license.activate(key: licenseKey, instanceName: "Testing")
                
                if let instanceId = response.instance?.id {
                    self.instanceId = instanceId
                }
                
                if let status = response.licenseKey?.status {
                    self.status = status.rawValue
                }
                
                if let meta = response.meta {
                    self.customerName = meta.customerName
                    self.customerEmail = meta.customerEmail
                }
            } catch let error as LemonSqueezyLicenseError {
                switch error {
                case .badServerResponse:
                    self.errorMessage = "Received an invalid response from the server"
                case .serverError(_, let errorMessage):
                    self.errorMessage = errorMessage
                }
            } catch {
                self.errorMessage = String(describing: error)
            }
        }
    }
    
    private func deactivate() {
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            defer { self.isLoading = false }
            
            do {
                let response = try await license.deactivate(key: licenseKey, instanceId: instanceId)
                
                if let instanceId = response.instance?.id {
                    self.instanceId = instanceId
                }
                
                if let status = response.licenseKey?.status {
                    self.status = status.rawValue
                }
                
                if let meta = response.meta {
                    self.customerName = meta.customerName
                    self.customerEmail = meta.customerEmail
                }
            } catch let error as LemonSqueezyLicenseError {
                switch error {
                case .badServerResponse:
                    self.errorMessage = "Received an invalid response from the server"
                case .serverError(_, let errorMessage):
                    self.errorMessage = errorMessage
                }
            } catch {
                self.errorMessage = String(describing: error)
            }
        }
    }
    
    private func validate() {
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            defer { self.isLoading = false }
            
            do {
                let response = try await license.validate(key: licenseKey)
                
                if let status = response.licenseKey?.status {
                    self.status = status.rawValue
                }
                
                if let meta = response.meta {
                    self.customerName = meta.customerName
                    self.customerEmail = meta.customerEmail
                }
            } catch let error as LemonSqueezyLicenseError {
                switch error {
                case .badServerResponse:
                    self.errorMessage = "Received an invalid response from the server"
                case .serverError(_, let errorMessage):
                    self.errorMessage = errorMessage
                }
            } catch {
                self.errorMessage = String(describing: error)
            }
        }
    }
}
