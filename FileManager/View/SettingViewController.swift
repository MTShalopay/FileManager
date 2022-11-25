//
//  SettingViewController.swift
//  FileManager
//
//  Created by Shalopay on 22.11.2022.
//

import UIKit

class SettingViewController: UIViewController {
    private let userDefaults = UserDefaults.standard
    
    private var settingHeaderText = ["Сортировка ячеек", "Показать размер фотографии", "Поменять пароль"]
    private var settingText = ["По алфавиту", "Отобразить размер", "Поменять пароль"]
    
    private lazy var settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.indentificator)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Настройки"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTableView.alwaysBounceVertical = false
    }
    
    func setupView() {
        view.addSubview(settingTableView)
        navigationController?.isToolbarHidden = false
        NSLayoutConstraint.activate([
            settingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func tapDidChange(sender: UISwitch) {
        switch sender.tag {
        case 0:
            print("table row switch Changed \(sender.tag)")
            userDefaults.set(sender.isOn, forKey: "sortedSwitch")
        case 1:
            print("table row switch Changed \(sender.tag)")
            userDefaults.set(sender.isOn, forKey: "presentSizePictures")
        default:
            print("ops")
        }
        
    }
    private func editPassword() {
        let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .automatic
            present(loginViewController, animated: true)
        loginViewController.loginState = .passEdit
        loginViewController.buttonState()
            loginViewController.buttonLogin.setTitle("Изменить пароль", for: .normal)
            loginViewController.passwordTextField.placeholder = "Введите новый пароль"
        
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.indentificator, for: indexPath) as? SettingCell else {
            let deafaultCell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
            return deafaultCell
        }
        
        let text = settingText[indexPath.section]
        cell.myLabel.text = text
        cell.selectionStyle = .none
        cell.mySwitch.tag = indexPath.section
        cell.mySwitch.addTarget(self, action: #selector(tapDidChange), for: .valueChanged)
        if indexPath.section == 2 {
            cell.mySwitch.isHidden = true
            cell.selectionStyle = .blue
            cell.myLabel.textAlignment = .center
            cell.myLabel.text = "Изменить пароль для входа"
        }
        switch indexPath.section {
        case 0:
            print("0 - \(cell.mySwitch.tag)")
            cell.mySwitch.isOn = userDefaults.bool(forKey: "sortedSwitch")
        case 1:
            print("1 - \(cell.mySwitch.tag)")
            cell.mySwitch.isOn = userDefaults.bool(forKey: "presentSizePictures")
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            print(indexPath.section - indexPath.row)
            editPassword()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return settingHeaderText[0]
        case 1:
            return settingHeaderText[1]
        case 2:
            return settingHeaderText[2]
        default:
            return "Нет данных"
        }
    }
    
}
