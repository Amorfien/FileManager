//
//  DocumentsViewController.swift
//  FileManager
//
//  Created by Pavel Grigorev on 11.03.2023.
//

import UIKit

class DocumentsViewController: UIViewController {

    private lazy var documentsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "documents")
        tableView.rowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

            private var documentURL: URL = URL(string: "file:///")!
            private var contents: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()
                getDocumentURL()
                getDocumentsContent()
    }

    private func setupNavigation() {
        navigationItem.title = "Documents"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add photo", style: .done, target: self, action: #selector(addPhotoButton))

    }


    private func setupView() {
        view.addSubview(documentsTableView)

        NSLayoutConstraint.activate([
            documentsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            documentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            documentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

            private func getDocumentURL() {
                do {
                    documentURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        //            print(documentURL, "🙊")
                } catch let error {
                    print(error, "🪲 get URL error")
                }
            }
            private func getDocumentsContent() {
                do {
                    contents = try FileManager.default.contentsOfDirectory(atPath: documentURL.path)
                } catch let error {
                    print(error, "🐙 get list error")
                }
                contents = contents.filter { $0 != ".DS_Store" }
                print(contents, "🖼️")
            }
            // * * *
            private func removeContent(by name: String) {
                do {
                    let imagePath =  documentURL.appending(path: name)
                    try FileManager.default.removeItem(at: imagePath)
                } catch let error {
                    print(error, "🦀 remove error")
                }
            }

    @objc private func addPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documents", for: indexPath)
        let imageURL = documentURL.appending(path: contents[indexPath.row])
        cell.imageView?.image = UIImage(contentsOfFile: imageURL.path)
        cell.imageView?.layer.borderWidth = 3
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        cell.textLabel?.text = contents[indexPath.row]
        cell.textLabel?.textAlignment = .right

        return cell
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        contents.isEmpty ? "Добавьте свою первую фотографию ↗︎" : nil
    }
    // * * *
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeContent(by: (tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
            getDocumentsContent()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imagePath =  documentURL.appending(path: "\(Int.random(in: 1000...9999)).jpg")
            FileManager.default.createFile(atPath: imagePath.path, contents: pickedImage.jpegData(compressionQuality: 1.0))
        }
        dismiss(animated: true) {
            self.getDocumentsContent()
            self.documentsTableView.reloadData()
        }
    }

}

