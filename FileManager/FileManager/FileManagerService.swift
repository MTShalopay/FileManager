//
//  FileManagerService.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import Foundation
import UIKit
class FileManagerService: FileManagerServiceProtocol {
    
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    func contentsOfDirectory(nameFolder: String?, comlitionHangler: (([String])) -> Void) {
        do {
        let contentsDirectory = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path  + "/\(nameFolder ?? "")")
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
    func createFile(nameFolder: String?, image: UIImage, imageName: String) {
//        let path = documentDirectory.path
//        FileManager.default.createFile(atPath: path + "/\(name)", contents: nil, attributes: nil)
        //let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentDirectory.path + "/\(nameFolder ?? "")"
        let fileUrl = URL(fileURLWithPath: path)
        
        let url = fileUrl.appendingPathComponent("Image \(String(describing: imageName)).jpeg")
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Unable to Write  Image Data to Disk")
            }
        }
        
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
