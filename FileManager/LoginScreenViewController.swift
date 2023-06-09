//
//  LoginScreenViewController.swift
//  FileManager
//
//  Created by Pavel Grigorev on 14.03.2023.
//

import UIKit
import KeychainAccess

class LoginScreenViewController: UIViewController {

    // MARK: - Resources
    enum Resources {
        static let keychainItemName = "FileManager_User"
    }

    // MARK: - Methods
    private let passLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизуйтесь"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.placeholder = "Пароль"
        textField.borderStyle = .bezel
        textField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        textField.leftViewMode = .always
        textField.contentVerticalAlignment = .center
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var passButton: UIButton = {
        let button = UIButton(configuration: .filled())
//        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    enum State: String {
        case noPassword = "Создать пароль"
        case savedPassword = "Введите пароль"
        case changePassword = "Сменить пароль"
    }
    private var state: State {
        didSet {
            passTextField.text = ""
            passButton.setTitle(state.rawValue, for: .normal)
        }
    }

    private var password = ""
    let keychain: Keychain

    var myTabBarController: TabBarController?

    // MARK: - INIT
    init(state: State) {
        self.state = state
        self.keychain = Keychain()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemGray6

        self.myTabBarController = TabBarController(loginScreen: self)

        setupUI()

//        print(keychain.allItems().count)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch state {
        case .savedPassword: passLabel.text = "Авторизуйтесь"
        case .noPassword: passLabel.text = "Зарегистрируйтесь"
        case .changePassword:
            passLabel.text = "Смените пароль"
            self.view.backgroundColor = .systemMint
        }
        setupButton()
    }


    // MARK: - Methods
    private func setupUI() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(passLabel)
        stackView.addArrangedSubview(passTextField)
        stackView.addArrangedSubview(passButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupButton() {
        self.passButton.setTitle(state.rawValue, for: .normal)
    }

    private func alerting(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

    @objc private func loginButtonDidTap() {
        switch state {
        case .noPassword, .changePassword:
            if password == "" {
                password = passTextField.text!
                passButton.setTitle("Повторите пароль", for: .normal)
                passTextField.text = ""
            } else {
                if password != passTextField.text! {
                    password = ""
                    passTextField.text = ""
                    setupButton()
                    alerting(message: "\nВы не смогли повторить пароль.\nВнимательней")
                } else {
//                    print("Password saved \(password)")
                    keychain[Resources.keychainItemName] = password
                    if state == .noPassword {
                        state = .savedPassword
                        self.show(myTabBarController!, sender: nil)
                    } else if state == .changePassword {
                        state = .savedPassword
                        self.dismiss(animated: true)
                    }
                }
            }
        case .savedPassword:
            if keychain[Resources.keychainItemName] == passTextField.text! {
                self.show(myTabBarController!, sender: nil)
            } else {
                alerting(message: "\nВы ввели неверный пароль.\nПопробуйте ещё")
                state = .savedPassword
            }
        }
        passTextField.text = ""

    }

}


extension LoginScreenViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passTextField.text!.count > 3 {
            passButton.isEnabled = true
        } else {
            passButton.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passTextField.resignFirstResponder()
        loginButtonDidTap()
        return true
    }
}


extension LoginScreenViewController: DeleteUserProtocol {
    func deleteUser() {
        self.state = .noPassword
        password = ""
        print("Юзер удалён")
    }
}
