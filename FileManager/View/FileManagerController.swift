//
//  ViewController.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import UIKit

class FileManagerController: UIViewController {
    private let fileManagerService = FileManagerService()
    private let userDefaults = UserDefaults.standard
    var directories: [String]?
    var isDir : ObjCBool = true
    private lazy var directoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.register(FileManagerCell.self, forCellReuseIdentifier: FileManagerCell.indetificator)
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
        fileManagerService.contentsOfDirectory(nameFolder: nil) { directories in
            self.directories = directories
        }
        print(fileManagerService.documentDirectory.path)
        setupNavigatorController(largeTitle: true, imageOneButton: UIImage(systemName: "folder.fill.badge.plus")!, imageTwoButton: UIImage(systemName: "photo.on.rectangle.angled")!, nameActionOneButton: #selector(createFolder), nameActionTwoButton: #selector(createImage))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        setupSortedFiles()
        directoriesTableView.reloadData()
    }
    
    private func setupSortedFiles() {
        if userDefaults.bool(forKey: "sortedSwitch") {
            directories?.sort(by: { $0 < $1 })
            directoriesTableView.reloadData()
        } else {
            directories?.sort(by: { $0 > $1 })
            directoriesTableView.reloadData()
        }
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
            self.setupSortedFiles()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileManagerCell.indetificator, for: indexPath) as? FileManagerCell else {
            let cellDefault = UITableViewCell(style: .value1, reuseIdentifier: "default")
            return cellDefault
        }
        if let directory = directories?[indexPath.row] {
            cell.nameLabel.text = directory
            let path = fileManagerService.documentDirectory.path + "/\(directory)"
            if FileManager.default.fileExists(atPath: fileManagerService.documentDirectory.path + "/\(directory)", isDirectory: &isDir) {
                if isDir.boolValue {
                    cell.sizeLabel.text = ""
                    cell.accessoryType = .disclosureIndicator
                    cell.isUserInteractionEnabled = true
                } else {
                    
                    if let imagePng = UIImage(contentsOfFile: path)?.pngData() {
                        if userDefaults.bool(forKey: "presentSizePictures") {
                            cell.sizeLabel.text = "\(imagePng.count / 1000000) Мбайт"
                        } else {
                            cell.sizeLabel.text = ""
                        }
                    }
                    cell.selectionStyle = .none
                    cell.accessoryType = .none
                    cell.isUserInteractionEnabled = false
                }
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let imageName = imageURL.lastPathComponent.first
        let image = info[.originalImage] as! UIImage
        
        fileManagerService.createFile(nameFolder: nil, image: image, imageName: "\(String(describing: imageName!))")
        directories?.append("Image \(imageName!).jpeg")
//        let path = fileManagerService.documentDirectory.path + "/Image \(imageName!).jpeg"
//        do {
//            let fileAttribute = try FileManager.default.attributesOfItem(atPath: path)
//            let fileSize = fileAttribute[FileAttributeKey.size] as! Int64
//            let fileType = fileAttribute[FileAttributeKey.type] as! String
//            let filecreationDate = fileAttribute[FileAttributeKey.creationDate] as! Date
//            let fileExtension = URL(fileURLWithPath: path).pathExtension
//            print("Name: \("Image \(imageName!).jpeg"), Size: \(fileSize / 1000000) Мбайт, Type: \(fileType), Date: \(filecreationDate), Extension: \(fileExtension)")
//        } catch {
//            print("Error: \(error)")
//        }
        dismiss(animated: true) {
            
        }
        self.setupSortedFiles()
        self.directoriesTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


