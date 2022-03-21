// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

@main
struct BooksApp: App {
    @StateObject var store: ReadingListStore = ReadingListStore()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                AuthorsView()
                    .tabItem { Text("Authors") }
                    .tag(1)
                    .environmentObject(store)
                BookCoversView()
                    .tabItem { Text("Books") }
                    .tag(2)
                    .environmentObject(store)
                BooksByAuthorView()
                    .tabItem { Text("By Author") }
                    .tag(3)
                    .environmentObject(store)
            }
        }
    }
}
