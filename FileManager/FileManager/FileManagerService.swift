//
//  FileManagerService.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import Foundation
class FileManagerService: FileManagerServiceProtocol {
    
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func contentsOfDirectory(comlitionHangler: (([String])) -> Void) {
        do {
        let contentsDirectory = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
            print(contentsDirectory)
            comlitionHangler(contentsDirectory)
        } catch {
            print("Error of contentsOfDirectory: \(error)")
        }
    }
    
    func createDirectory(name: String) {
        print(#function)
        let folderPath = documentDirectory.appendingPathComponent("\(name)")
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func createFile(name: String) {
        let path = documentDirectory.path
        FileManager.default.createFile(atPath: path + "/\(name)", contents: nil, attributes: nil)
    }
    
    func removeContent(name: String) {
        let path = documentDirectory.path
        do {
            try FileManager.default.removeItem(atPath: path + "/\(name)")
        } catch {
            print("ERROR removeContent: \(error)")
        }
    }
    
     func setupTitleDocumentDbirectory(comlitionHangler: ((String)) -> Void) {
        let titleName = documentDirectory.lastPathComponent
        comlitionHangler(titleName)
    }

}
