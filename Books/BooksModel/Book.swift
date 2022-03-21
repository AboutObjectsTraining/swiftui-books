// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

final class Book: ObservableObject, Codable, Identifiable, CustomStringConvertible {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case year
        case rating
    }
    
    var id: UUID = UUID()
    @Published var title: String
    @Published var year: Int?
    @Published var rating: Rating = .none

    var description: String {
        return "\n\tid: \(id), title: \(title), year: \(year?.description ?? "null")"
    }
    
    init(id: UUID, title: String, year: Int? = nil, rating: Rating = .none) {
        self.id = id
        self.title = title
        self.year = year
        self.rating = rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(Int.self, forKey: .year)
        rating = (try container.decodeIfPresent(Rating.self, forKey: .rating)) ?? .none
    }
}

// MARK: - Encoding
extension Book {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(year, forKey: .year)
        try container.encode(rating, forKey: .rating)
    }
}
