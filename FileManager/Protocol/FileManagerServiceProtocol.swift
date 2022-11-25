//
//  FileManagerServiceProtocol.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol: AnyObject {
    func contentsOfDirectory(nameFolder: String?, comlitionHangler: (([String])) -> Void)
    func createDirectory(name: String)
    func createFile(nameFolder: String?, image: UIImage, imageName: String)
    func removeContent(name: String)
    func setupTitleDocumentDbirectory(comlitionHangler: ((String)) -> Void)
}

struct Content {
    let folder: UIImage?
    let image: UIImage?
}
