// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

enum Rating: Int, CaseIterable, Identifiable, Codable {
    case none
    case one
    case two
    case three
    case four
    case five
    
    var id: Int {
        return self.rawValue
    }
    
    var stars: String {
        switch (self) {
            case .none : return "⭐︎⭐︎⭐︎⭐︎⭐︎"
            case .one  : return "⭑⭐︎⭐︎⭐︎⭐︎"
            case .two  : return "⭑⭑⭐︎⭐︎⭐︎"
            case .three: return "⭑⭑⭑⭐︎⭐︎"
            case .four : return "⭑⭑⭑⭑⭐︎"
            case .five : return "⭑⭑⭑⭑⭑"
        }
    }
}
