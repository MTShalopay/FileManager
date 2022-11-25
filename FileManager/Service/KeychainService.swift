//
//  KeychainService.swift
//  FileManager
//
//  Created by Shalopay on 14.11.2022.
//

import Foundation
import KeychainAccess

class KeychainService: KeychainServiceProtocol {
    static let shared = KeychainService()
    let keychain = Keychain(service: "FileManager")
    
    private init() {}
    
    func getData() -> String? {
        do {
            if let result = try keychain.get("password") {
                return result
            }
        } catch {
            print("Error setupKeyChain: \(error)")
        }
        return nil
    }
    
    func saveData(name: String) {
       keychain["password"] = name
    }
    
    func updateData(name: String) {
        saveData(name: name)
    }
    
    func remove(for name: String) {
        do {
            try keychain.remove(name)
        } catch {
            print("Error remove: \(error)")
        }
    }
    func removeAll() {
        do {
            try keychain.removeAll()
        } catch {
            print("Error removeAll: \(error)")
        }
    }
  
}
