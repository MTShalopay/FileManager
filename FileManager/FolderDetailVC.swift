//
//  FolderDetailVC.swift
//  FileManager
//
//  Created by Shalopay on 07.11.2022.
//

import UIKit

class FolderDetailVC: UIViewController {
    private let fileManagerService = FileManagerService()
    var name: String = ""
    var folder: [String]?
    var isDir : ObjCBool = false
    
    
    private lazy var folderTableView: UITableView = {
      let tableView = UITableView(frame: .zero, style: .grouped)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
      tableView.delegate = self
      tableView.dataSource = self
      tableView.translatesAutoresizingMaskIntoConstraints = false
      return tableView
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let contentsDirectory = try FileManager.default.contentsOfDirectory(atPath: fileManagerService.documentDirectory.path + "/\(name)")
            print(contentsDirectory)
            self.folder = contentsDirectory
        } catch {
            print("Error of contentsOfDirectory: \(error)")
        }
        setupNavigatorController(largeTitle: false, imageOneButton: UIImage(systemName: "folder.fill.badge.plus")!, imageTwoButton: UIImage(systemName: "photo.on.rectangle.angled")!, nameActionOneButton: #selector(createFolder), nameActionTwoButton: #selector(createImage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigatorController()
        setupView()
    }
    
    
    func setupNavigatorController() {
        self.title = name
        view.backgroundColor = .systemBackground
    }
    func setupView() {
        view.addSubview(folderTableView)
        NSLayoutConstraint.activate([
            folderTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            folderTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            folderTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            folderTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    @objc private func createFolder() {
        customAlertController { text in
            self.folder?.append(text)
            let folderPath = self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(text)"
            print(folderPath)
            if !FileManager.default.fileExists(atPath: folderPath) {
                do {
                    try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.folderTableView.reloadData()
        }
    }
    
    @objc private func createImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true) {
        }
    }
}

extension FolderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        if let nameItem = folder?[indexPath.row] {
            cell.textLabel?.text = nameItem
            if FileManager.default.fileExists(atPath: self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(nameItem)", isDirectory: &isDir) {
                if isDir.boolValue {
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.selectionStyle = .none
                    cell.isUserInteractionEnabled = false
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section: \(indexPath.section) - row \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("DELETE")
            let nameItem = folder![indexPath.row]
            try? FileManager.default.removeItem(atPath: self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(nameItem)")
            folder?.remove(at: indexPath.row)
            self.folderTableView.reloadData()
        default:
            print("default")
        }
    }
    
    
}

extension FolderDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[.imageURL] as! URL
        
        let path = fileManagerService.documentDirectory.path + "/\(name)" + "/\(imageURL.lastPathComponent)"
        print(path)
        FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        do {
            let fileAttribute = try FileManager.default.attributesOfItem(atPath: path)
              let fileSize = fileAttribute[FileAttributeKey.size] as! Int64
              let fileType = fileAttribute[FileAttributeKey.type] as! String
              let filecreationDate = fileAttribute[FileAttributeKey.creationDate] as! Date
            print(fileSize, fileType, filecreationDate)
        } catch {
            print("Error: \(error)")
        }
        
        folder?.append(imageURL.lastPathComponent)
        dismiss(animated: true, completion: nil)
        self.folderTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
}
