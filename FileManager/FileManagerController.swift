//
//  ViewController.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import UIKit

class FileManagerController: UIViewController {
    private let fileManagerService = FileManagerService()
    var directories: [String]?
    var isDir : ObjCBool = false
    
      private lazy var directoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .systemBackground
        fileManagerService.setupTitleDocumentDbirectory { title in
            DispatchQueue.main.async {
                self.title = title
            }
        }
        fileManagerService.contentsOfDirectory { directories in
            self.directories = directories
        }
        
        setupNavigatorController(largeTitle: true, imageOneButton: UIImage(systemName: "folder.fill.badge.plus")!, imageTwoButton: UIImage(systemName: "photo.on.rectangle.angled")!, nameActionOneButton: #selector(createFolder), nameActionTwoButton: #selector(createImage))
        
    }
    
    private func setupView() {
        view.addSubview(directoriesTableView)
        NSLayoutConstraint.activate([
            directoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            directoriesTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
            directoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            directoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc private func createFolder() {
        customAlertController { text in
            self.directories?.append(text)
            self.fileManagerService.createDirectory(name: text)
            self.directoriesTableView.reloadData()
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
extension FileManagerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directories?.count ?? 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        if let directory = directories?[indexPath.row] {
            cell.textLabel?.text = directory
            if FileManager.default.fileExists(atPath: fileManagerService.documentDirectory.path + "/\(directory)", isDirectory: &isDir) {
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
        print("didselect \(indexPath.section) - \(indexPath.row)")
        let directory = directories![indexPath.row]
        let folderDetail = FolderDetailVC()
        folderDetail.name = directory
        navigationController?.pushViewController(folderDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("DELETE")
            let directory = directories![indexPath.row]
            fileManagerService.removeContent(name: directory)
            directories?.remove(at: indexPath.row)
            self.directoriesTableView.reloadData()
        default:
            print("default")
        }
    }
    
}

extension FileManagerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[.imageURL] as! URL
        var imageName = imageURL.lastPathComponent.first
        print("image\(imageName)")
        
        fileManagerService.createFile(name: "image\(imageName)")
        directories?.append("image \(imageName!)")
        dismiss(animated: true, completion: nil)
        self.directoriesTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
}


