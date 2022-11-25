//
//  LoginViewController.swift
//  FileManager
//
//  Created by Shalopay on 14.11.2022.
//

import UIKit

class LoginViewController: UIViewController {
    enum LoginState {
        case signIn, signUp, passEdit
    }
    var loginState = LoginState.signUp
    private var shadowSwitch = true
    internal let keychainService = KeychainService.shared
    private var password: String = ""

    internal lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.backgroundColor = UIColor.white
        textField.font = UIFont.boldSystemFont(ofSize: 17)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2.0
        textField.borderStyle = .none
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 4, height: 4)
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOpacity = 0.7
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clipsToBounds = false
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    internal lazy var buttonLogin: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.7
        button.clipsToBounds = false
        //button.setTitle("Создать пароль", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var verticalStack: UIStackView = {
       let stack = UIStackView()
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.clipsToBounds = true
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonState()
        setupView()
        setupTap()
        if (keychainService.getData() != nil) {
            loginState = .signIn
        } else {
            loginState = .signUp
        }
        buttonState()
    }
    
    @objc func buttonAction() {
        if shadowSwitch {
            buttonLogin.layer.shadowOffset = CGSize.zero
        } else {
            buttonLogin.layer.shadowOffset = CGSize(width: 4, height: 4)
        }
        shadowSwitch = !shadowSwitch
        switch loginState {
        case .signIn:
            print("signin")
            guard let passworData = keychainService.getData() else { return }
            if passwordTextField.text! == passworData {
                let fileManagerVC = FileManagerController()
                self.navigationController?.setViewControllers([fileManagerVC], animated: true)
            } else {
                alertErrorPassword(text: "Пароли не верны")
            }
            
        case .signUp:
            print("signup")
            guard passwordTextField.text!.count >= 4, !passwordTextField.text!.isEmpty else {
                alertErrorPassword(text: "Пароль должен состоять минимум из четырёх символов")
                passwordTextField.text = ""
                return
            }
            if password == "" {
                password = passwordTextField.text!
                passwordTextField.text = ""
                buttonLogin.setTitle("Повторите пароль", for: .normal)
            } else {
                if passwordTextField.text == password {
                    keychainService.saveData(name: passwordTextField.text!)
                    password = ""
                    let tabBarController = UITabBarController()
                    let fileManagerVC = FileManagerController()
                    fileManagerVC.tabBarItem.title = "Файловый менеджер"
                    fileManagerVC.tabBarItem.image = UIImage(systemName: "folder")
                    let fileManagerNc = UINavigationController(rootViewController: fileManagerVC)
                    
                    let settingViewController = SettingViewController()
                    settingViewController.tabBarItem.title = "Настройки"
                    settingViewController.tabBarItem.image = UIImage(systemName: "gearshape")
                    let settingViewControllerNc = UINavigationController(rootViewController: settingViewController)
                    tabBarController.viewControllers = [fileManagerNc, settingViewControllerNc]
                    navigationController?.navigationBar.isHidden = true
                    self.navigationController?.setViewControllers([tabBarController], animated: true)
                } else {
                    alertErrorPassword(text: "Пароли к сожелению не совпадают")
                    passwordTextField.text = ""
                }
            }
        case .passEdit:
            buttonLogin.setTitle("Изменить пароль", for: .normal)
            print("passedit")
            guard passwordTextField.text!.count >= 4, !passwordTextField.text!.isEmpty else {
                alertErrorPassword(text: "Пароль должен состоять минимум из четырёх символов")
                passwordTextField.text = ""
                return
            }
            keychainService.saveData(name: passwordTextField.text!)
            alertErrorPassword(text: "Пароль изменен на \(passwordTextField.text!)")
        }
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(passwordTextField)
        verticalStack.addArrangedSubview(buttonLogin)
        NSLayoutConstraint.activate([
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            verticalStack.heightAnchor.constraint(equalToConstant: 120),
            
        ])
    }
    
    internal func buttonState() {
        switch loginState {
        case .signUp:
            buttonLogin.setTitle("Создайте пароль", for: .normal)
        case .signIn:
            buttonLogin.setTitle("Вход", for: .normal)
        case .passEdit:
            buttonLogin.setTitle("Изменить пароль", for: .normal)
        }
    }
   
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        print(passwordTextField.text)
        //alertError()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard()
        return false
    }
    
}
