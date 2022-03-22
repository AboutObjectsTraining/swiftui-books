// Copyright (C) 2022 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct ButtonLabels {
    static var plus: some View {
        Image(systemName: "plus")
    }
    
    static var done: some View {
        Text("Done")
    }
    
    static var cancel: some View {
        Text("Cancel")
    }
    
    static var info: some View {
        Image(systemName: "info.circle")
    }
    
    static func grid(isShowing: Bool) -> some View {
        return Image(systemName: "square.grid.3x3\(isShowing ? ".fill" : "")")
    }
}
