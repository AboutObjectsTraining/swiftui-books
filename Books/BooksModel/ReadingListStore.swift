// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation
import Combine

extension String: Error {
    // TODO: custom error type
}

private let decoder = JSONDecoder()
private let encoder = JSONEncoder()
private let defaultJsonFile = File(name: "BooksByAuthor", type: "json")

@available(iOS 13.0, *)
class ReadingListStore: ObservableObject
{
    @Published var readingList: ReadingList?
    
    var authors: [Author] {
        readingList?.authors ?? []
    }
    var allBooks: [Book] {
        return authors.flatMap { $0.books }
    }
    
    private var readingListSubscription: AnyCancellable?
    private var jsonFile: File
    
    init(jsonFile: File = defaultJsonFile) {
        self.jsonFile = jsonFile
        if !jsonFile.existsInDocumentsDirectory {
            jsonFile.copyFromMainBundleToDocumentsDirectory()
        }
        loadReadingList(from: jsonFile.documentUrl)
    }

    private func loadReadingList(from fileUrl: URL) {
        // Try to load JSON data from filesystem off the main thread.
        let readingListDataFuture = Future<Data, String> { promise in
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: fileUrl) {
                    promise(.success(data))
                } else {
                    promise(.failure("Unable to load author data at url \(fileUrl)"))
                }
            }
        }
        
        // Decode authors array from JSON data.
        readingListSubscription = readingListDataFuture
            .decode(type: ReadingList.self, decoder: JSONDecoder())
            .print()
            .receive(on: DispatchQueue.main)
            .sink {
                print($0)
            } receiveValue: {
                self.readingList = $0
            }
    }
    
    func addAuthor(_ author: Author) {
        objectWillChange.send()
        readingList?.addAuthor(author)
        save()
    }
    
    // TODO: Delete me!
    func index(of author: Author) -> Int? {
        return readingList?.index(of: author)
    }
    
    func save() {
        guard let encodedReadingList = try?  encoder.encode(readingList) else {
            print("Unable to encode reading list \(readingList?.description ?? "null")")
            return
        }

        try? encodedReadingList.write(to: jsonFile.documentUrl)
    }
}
