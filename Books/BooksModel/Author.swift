// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

final class Author: ObservableObject, Codable, Identifiable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case books
        case rating
    }
    
    var id: UUID = UUID()
    // TODO: Encode/decode rating
    @Published var name: String
    @Published var books: [Book]
    @Published var rating: Rating = .none
    
    var imageName: String {
        return name.components(separatedBy: " ").last ?? "DefaultImage"
    }
    
    var description: String {
        return "\n\tauthor: \(name), books: \(books)"
    }
    
    init(id: UUID = UUID(), name: String, books: [Book]) {
        self.name = name
        self.books = books
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        books = try container.decode([Book].self, forKey: .books)
        rating = (try container.decodeIfPresent(Rating.self, forKey: .rating)) ?? .none
    }
    
    func index(of book: Book) -> Int? {
        return books.firstIndex { $0.id == book.id }
    }
}

// - MARK: Encoding
extension Author
{
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(books, forKey: .books)
        try container.encode(rating, forKey: .rating)
    }
}
