// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

final class ReadingList: ObservableObject, Codable, Identifiable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case authors
    }
    
    var id: UUID = UUID()
    @Published var title: String
    @Published var authors: [Author]
    
    var description: String {
        return "title: \(title):\nauthors: \(authors)"
    }
    
    init(id: UUID, title: String, authors: [Author]) {
        self.id = id
        self.title = title
        self.authors = authors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        authors = try container.decode([Author].self, forKey: .authors)
    }
}

// MARK: - Managing authors
extension ReadingList {
    // TODO: Delete me!
    func index(of author: Author) -> Int? {
        return authors.firstIndex { $0.id == author.id }
    }
    
    func addAuthor(_ author: Author) {
        authors.append(author)
    }
}

// MARK: - Encoding

extension ReadingList {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authors)
    }
}
