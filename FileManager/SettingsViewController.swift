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

class SettingsViewController: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["По возрастанию", "По убыванию", "Без сортировки"])
        segment.selectedSegmentIndex = 0
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

    weak var deleteDelegate: DeleteUserProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true

        self.view.backgroundColor = .systemYellow

        setupUI()
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

    @objc private func changePassword() {

    }

    @objc private func deleteUser() {
        Keychain()[LoginScreenViewController.Resources.keychainItemName] = nil
        print(Keychain().allItems().count)
        // FIXME: - Никак не получается откатиться на экран логина не создавая его заново

//        show(LoginScreenViewController(state: .noPassword), sender: nil)
//        self.dismiss(animated: true)
//        navigationController?.popToRootViewController(animated: true)
//        navigationController?.dismiss(animated: true)
//        tabBarController?.dismiss(animated: true)
//        navigationController?.tabBarController?.dismiss(animated: true)
//        tabBarController?.navigationController?.dismiss(animated: true)
//        self.navigationController?.navigationItem.backAction.
        deleteDelegate?.deleteUser()
    }
    
}
