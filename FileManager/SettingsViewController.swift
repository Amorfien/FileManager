//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Pavel Grigorev on 14.03.2023.
//

import UIKit
import KeychainAccess

protocol DeleteUserProtocol: AnyObject {
    func deleteUser()
}
protocol EmptyTableProtocol: AnyObject {
    func emptyTable()
}
protocol SortingTableProtocol: AnyObject{
    func sortingTable(increasing: Bool)
}

class SettingsViewController: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["По возрастанию", "По убыванию", "Без сортировки"])
        segment.addTarget(self, action: #selector(selectorDidChange), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private lazy var changePassButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("Сменить пароль", for: .normal)
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var deleteUserButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.setTitle("Удалить пользователя", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    weak var emptyTableDelegate: EmptyTableProtocol?
    weak var deleteUserDelegate: DeleteUserProtocol?
    weak var sortingTableDelegate: SortingTableProtocol?

    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true

        self.view.backgroundColor = .systemYellow

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.selectedSegmentIndex = userDefaults.integer(forKey: "sorting")
    }

    private func setupUI() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(changePassButton)
        stackView.addArrangedSubview(deleteUserButton)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            stackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func selectorDidChange() {
        userDefaults.set(segmentedControl.selectedSegmentIndex, forKey: "sorting")

        // необязательное обращение к делегату
//        switch segmentedControl.selectedSegmentIndex {
//        case 0: sortingTableDelegate?.sortingTable(increasing: true)
//        case 1: sortingTableDelegate? .sortingTable(increasing: false)
//        default: break
//        }
    }

    @objc private func changePassword() {
        present(LoginScreenViewController(state: .changePassword), animated: true)
    }

    @objc private func deleteUser() {
        Keychain()[LoginScreenViewController.Resources.keychainItemName] = nil
        print(Keychain().allItems().count)
        FileManagerService.shared.removeAll()

        deleteUserDelegate?.deleteUser()
        emptyTableDelegate?.emptyTable()
    }
    
}
