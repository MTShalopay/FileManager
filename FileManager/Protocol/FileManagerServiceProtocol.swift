//
//  FileManagerServiceProtocol.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import Foundation

protocol FileManagerServiceProtocol {
    func contentsOfDirectory(comlitionHangler: (([String])) -> Void)
    func createDirectory(name: String)
    func createFile(name: String)
    func removeContent(name: String)
    func setupTitleDocumentDbirectory(comlitionHangler: ((String)) -> Void)
}

struct Content {
    let folder: String
    let file: String
}
