//
//  FileManager.swift
//  FileManager
//
//  Created by Pavel Grigorev on 16.03.2023.
//

import Foundation

final class FileManagerService {

    static let shared = FileManagerService()

    var documentURL: URL = URL(string: "file:///")!
    var contents: [String] = []
    var sortingType = 3

    private init() {
        getDocumentURL()
        sortingType = UserDefaults.standard.integer(forKey: "sorting")
        getDocumentsContent()
    }

    private func getDocumentURL() {
        do {
            documentURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            print(documentURL, "🙊")
        } catch let error {
            print(error, "🪲 get URL error")
        }
    }
    func getDocumentsContent() {
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: documentURL.path)
        } catch let error {
            print(error, "🐙 get list error")
        }
        contents = contents.filter { $0 != ".DS_Store" }
        if sortingType == 0 {
            contents.sort(by: > )
        } else if sortingType == 1 {
            contents.sort(by: < )
        }
        print(contents, "🖼️")
    }
    // * * *
    func removeContent(by name: String) {
        do {
            let imagePath =  documentURL.appending(path: name)
            try FileManager.default.removeItem(at: imagePath)
        } catch let error {
            print(error, "🦀 remove error")
        }
    }

    func removeAll() {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
            for file in files {
                try FileManager.default.removeItem(atPath: file.path())
            }
        } catch let error {
            print(error, "💣 remove ALL error")
        }
    }
    

}
