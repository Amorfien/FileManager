//
//  TabBarController.swift
//  FileManager
//
//  Created by Pavel Grigorev on 14.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    let loginScreen: DeleteUserProtocol

    init(loginScreen: DeleteUserProtocol) {
        self.loginScreen = loginScreen
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    private func setup() {
        let documentsViewController = DocumentsViewController()
        let settingsViewController = SettingsViewController()
        settingsViewController.emptyTableDelegate = documentsViewController
        settingsViewController.sortingTableDelegate = documentsViewController
        settingsViewController.deleteUserDelegate = loginScreen
        let documentsNavViewController = UINavigationController(rootViewController: documentsViewController)
        let settingsNavViewController = UINavigationController(rootViewController: settingsViewController)

        self.viewControllers = [documentsNavViewController, settingsNavViewController]
        let item1 = UITabBarItem(title: "Файлы", image: UIImage(systemName: "list.bullet.circle"), tag: 0)
        let item2 = UITabBarItem(title: "Настройки", image:  UIImage(systemName: "gearshape.2"), tag: 1)
        documentsViewController.tabBarItem = item1
        settingsViewController.tabBarItem = item2
        tabBar.backgroundColor = .systemGray5

    }

}
