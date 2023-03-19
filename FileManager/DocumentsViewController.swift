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

    let files = FileManagerService.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let sortingType = UserDefaults.standard.integer(forKey: "sorting")
        if sortingType == 0 {
            sortingTable(increasing: true)
        } else if sortingType == 1 {
            sortingTable(increasing: false)
        }
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


    @objc private func addPhotoButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "documents", for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "documents")
        let imageURL = files.documentURL.appending(path: files.contents[indexPath.row])
        cell.imageView?.image = UIImage(contentsOfFile: imageURL.path)
        cell.imageView?.layer.borderWidth = 3
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        let dayString = files.contents[indexPath.row].components(separatedBy: "_")
        cell.textLabel?.text = dayString[0]
        cell.detailTextLabel?.text = dayString[1]
        cell.textLabel?.textAlignment = .right
        cell.detailTextLabel?.textAlignment = .right

        return cell
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        files.contents.isEmpty ? "Добавьте свою первую фотографию ↗︎" : nil
    }
    // * * *
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fileName = (tableView.cellForRow(at: indexPath)?.textLabel?.text)! + "_" + (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text)!
            files.removeContent(by: fileName)
            files.getDocumentsContent()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMddyyyy_HHmmss"
            let filename = formatter.string(from: date)

            let imagePath =  files.documentURL.appending(path: "\(filename).jpg")
            FileManager.default.createFile(atPath: imagePath.path, contents: pickedImage.jpegData(compressionQuality: 1.0))
        }
        dismiss(animated: true) {
            self.files.getDocumentsContent()
            self.documentsTableView.reloadData()
        }
    }

}

extension DocumentsViewController: EmptyTableProtocol {
    func emptyTable() {
        files.getDocumentsContent()
        documentsTableView.reloadData()
    }
}

extension DocumentsViewController: SortingTableProtocol {
    func sortingTable(increasing: Bool) {
//        print("Sorting tableview delegate increasing = \(increasing)")
        increasing ? files.contents.sort(by: > ) : files.contents.sort(by: < )
        documentsTableView.reloadData()
    }


}

