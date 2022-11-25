//
//  KeychainServiceProtocol.swift
//  FileManager
//
//  Created by Shalopay on 14.11.2022.
//

import Foundation

protocol KeychainServiceProtocol: AnyObject {
    func getData() -> String?
    func saveData(name: String)
    func updateData(name: String)
    func remove(for name: String)
    func removeAll()
}
