// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

private let lightBackgroundColor = Color(.sRGB, white: 0, opacity: 0.02)
private let darkBackgroundColor =  Color(.sRGB, white: 1, opacity: 0.12)

struct BookCoversView: View {
    @State var isShowingGrid = false
    @EnvironmentObject var store: ReadingListStore
    @Environment(\.colorScheme) private var colorScheme
    
    var shadowColor: Color { return (colorScheme == .light ? .gray : .white) }
    var backgroundColor: Color { return (colorScheme == .light ? lightBackgroundColor : darkBackgroundColor) }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !isShowingGrid {
                    ForEach(store.authors) { author in
                        CoversForAuthorView(author: author)
                            .shadow(color: shadowColor, radius: 9, x: 0, y: 2)
                    }
                }
                else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                        ForEach(store.allBooks) { book in
                            CoverImageCell(book: book)
                                .shadow(color: shadowColor, radius: 10, x: 0, y: 2)
                        }
                    }
                    .padding(.all, 12.0)
                    .border(Color.secondary, width: 0.25)
                    .background(backgroundColor)
                }
            }
            .navigationBarTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingGrid.toggle() },
                           label: { isShowingGrid ?
                        Image(systemName: "square.grid.3x3.fill") :
                        Image(systemName: "square.grid.3x3")
                    })
                }
            }
        }
    }
}

struct CoverImageCell: View {
    @ObservedObject var book: Book
    
    var body: some View {
        Image(book.title)
            .resizable()
            .scaledToFit()
    }
}

struct CoversForAuthorView: View {
    @ObservedObject var author: Author
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(author.name)
                .font(.headline)
                .foregroundColor(Color.primary)
                .textCase(.uppercase)
                .padding(.top, 6.0)
            ScrollView(.horizontal) {
                ScrollableCovers(author: author)
            }
            .padding(.vertical)
        }
        .border(Color.secondary, width: 0.25)
        .background((colorScheme == .light ? lightBackgroundColor : darkBackgroundColor))
    }
}

struct ScrollableCovers: View {
    @ObservedObject var author: Author
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))]) {
            ForEach(author.books) { book in
                CoverImageCell(book: book)
            }
            // TODO: Need a better way to constrain scroll view width
            .frame(maxWidth: 600, maxHeight: 160)
        }
        .padding(.leading, 12.0)
    }
}

struct BooksCoversView_Previews: PreviewProvider {
    static var previews: some View {
        BookCoversView()
            .environmentObject(TestData.store)
        BookCoversView()
            .environmentObject(TestData.store)
            .preferredColorScheme(.dark)
    }
}
