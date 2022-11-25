//
//  FolderDetailVC.swift
//  FileManager
//
//  Created by Shalopay on 07.11.2022.
//

import UIKit

class FolderDetailVC: UIViewController {
    private let userDefaults = UserDefaults.standard
    private let fileManagerService = FileManagerService()
    var name: String = ""
    var folders: [String]?
    var isDir : ObjCBool = true
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
        fileManagerService.contentsOfDirectory(nameFolder: name) { folder in
            self.folders = folder
        }
        setupNavigatorController(largeTitle: false, imageOneButton: UIImage(systemName: "folder.fill.badge.plus")!, imageTwoButton: UIImage(systemName: "photo.on.rectangle.angled")!, nameActionOneButton: #selector(createFolder), nameActionTwoButton: #selector(createImage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigatorController()
        setupView()
        setupSortedFiles()
    }
    
    private func setupSortedFiles() {
        if userDefaults.bool(forKey: "sortedSwitch") {
            folders?.sort(by: { $0 < $1 })
            folderTableView.reloadData()
        } else {
            folders?.sort(by: { $0 > $1 })
            folderTableView.reloadData()
        }
    }
    
    private func setupNavigatorController() {
        self.title = name
        view.backgroundColor = .systemBackground
    }
    private func setupView() {
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
            self.folders?.append(text)
            let folderPath = self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(text)"
            print(folderPath)
            if !FileManager.default.fileExists(atPath: folderPath) {
                do {
                    try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.setupSortedFiles()
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
        return folders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "default")
        if let nameItem = folders?[indexPath.row] {
            cell.textLabel?.text = nameItem
            let path = fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(nameItem)"
            if FileManager.default.fileExists(atPath: self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(nameItem)", isDirectory: &isDir) {
                if isDir.boolValue {
                    cell.detailTextLabel?.text = ""
                    cell.accessoryType = .disclosureIndicator
                    cell.isUserInteractionEnabled = true
                } else {
                    if let imagePng = UIImage(contentsOfFile: path)?.pngData() {
                        if userDefaults.bool(forKey: "presentSizePictures") {
                            cell.detailTextLabel?.text = "\(imagePng.count / 1000000) Мбайт"
                        } else {
                            cell.detailTextLabel?.text = ""
                        }
                    }
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
            let nameItem = folders![indexPath.row]
            try? FileManager.default.removeItem(atPath: self.fileManagerService.documentDirectory.path + "/\(self.name)" + "/\(nameItem)")
            folders?.remove(at: indexPath.row)
            self.folderTableView.reloadData()
        default:
            print("default")
        }
    }
    
    
}

extension FolderDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[.imageURL] as! URL
        let imageName = imageURL.lastPathComponent.first
        let image = info[.originalImage] as! UIImage
        fileManagerService.createFile(nameFolder: name, image: image, imageName: "\(String(describing: imageName!))")
        folders?.append("Image \(imageName!).jpeg")
        dismiss(animated: true, completion: nil)
        self.folderTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
