//
//  FileManager.swift
//  FileManager
//
//  Created by Pavel Grigorev on 16.03.2023.
//

import Foundation

final class FileManagerService {

    static let shared = FileManagerService()

    private var documentURL: URL = URL(string: "file:///")!
    private var contents: [String] = []

    private init() {
        getDocumentURL()
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
    

}
