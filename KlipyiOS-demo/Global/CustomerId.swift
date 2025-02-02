//
//  CustomerId.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 12.01.25.
//

import Foundation

enum CustomerIDManager {
  private static let customerIDKey = "com.klipy.customerID"
  private static let prefix = "KlipyiOSDemo"
  
  /// Returns the unique customer ID, generating and storing a new one if needed
  static var customerID: String {
    if let existingID = UserDefaults.standard.string(forKey: customerIDKey) {
      return existingID
    }
    
    let newID = generateNewCustomerID()
    UserDefaults.standard.set(newID, forKey: customerIDKey)
    return newID
  }
  
  private static func generateNewCustomerID() -> String {
    let uuid = UUID().uuidString
    let timestamp = Int(Date().timeIntervalSince1970)
    return "\(prefix)-\(uuid)-\(timestamp)"
  }
  
  static func regenerateCustomerID() {
    let newID = generateNewCustomerID()
    UserDefaults.standard.set(newID, forKey: customerIDKey)
  }
  
  static func resetCustomerID() {
    UserDefaults.standard.removeObject(forKey: customerIDKey)
  }
}

// Example extension to add Keychain support if needed
extension CustomerIDManager {
  /// Alternative implementation using Keychain for more secure storage
  static func secureCustomerID() -> String {
    // Add Keychain implementation here if needed
    // This would be more secure than UserDefaults
    // but requires additional setup
    customerID
  }
}
