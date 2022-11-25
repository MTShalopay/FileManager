//
//  SceneDelegate.swift
//  FileManager
//
//  Created by Shalopay on 21.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let keychainService = KeychainService.shared
    let tabBarController = UITabBarController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let fileManagerVC = FileManagerController()
        fileManagerVC.tabBarItem.title = "Файловый менеджер"
        fileManagerVC.tabBarItem.image = UIImage(systemName: "folder")
        let fileManagerNc = UINavigationController(rootViewController: fileManagerVC)
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem.title = "Настройки"
        settingViewController.tabBarItem.image = UIImage(systemName: "gearshape")
        let settingViewControllerNc = UINavigationController(rootViewController: settingViewController)
        
        tabBarController.viewControllers = [fileManagerNc, settingViewControllerNc]
        
        let loginVC = LoginViewController()
        let navVC = UINavigationController(rootViewController: loginVC)
        print("SceneDelegate: \(keychainService.getData())")
//        keychainService.removeAll()
        let passwordData = keychainService.getData()
        if passwordData != nil {
            window?.rootViewController = tabBarController
        } else {
            window?.rootViewController = navVC
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

