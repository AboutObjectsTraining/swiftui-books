// Copyright (C) 2021 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

struct TestData {
    static let book = Book(id: UUID(), title: "Romeo and Juliet", year: 1599, rating: .four)
    static let books = [
        book,
        Book(id: UUID(), title: "Julius Caesar", year: 1602, rating: .five),
    ]
    static let author = Author(name: "William Shakespeare", books: books)
    static let store = ReadingListStore()
}

