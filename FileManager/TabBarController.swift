//
//  TabBarController.swift
//  FileManager
//
//  Created by Pavel Grigorev on 14.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let documentsViewController = UINavigationController(rootViewController: DocumentsViewController())
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())

        self.viewControllers = [documentsViewController, settingsViewController]
        let item1 = UITabBarItem(title: "Файлы", image: UIImage(systemName: "list.bullet.circle"), tag: 0)
        let item2 = UITabBarItem(title: "Настройки", image:  UIImage(systemName: "gearshape.2"), tag: 1)
        documentsViewController.tabBarItem = item1
        settingsViewController.tabBarItem = item2
        tabBar.backgroundColor = .systemGray5

    }

}
