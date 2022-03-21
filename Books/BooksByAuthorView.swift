// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BooksByAuthorView: View {
    @EnvironmentObject var store: ReadingListStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.authors) { author in
                    Section(header: AuthorCellView(author: author).padding(.vertical)) {
                        ForEach(author.books) { book in
                            BookSummaryCell(book: book, font: .callout)
                                .frame(maxHeight: 80)
                        }
                        .padding(.leading, 12.0)
                    }
                }
            }
            .navigationBarTitle("Books by Author")
        }
    }
}

struct AuthorCellView: View {
    var author: Author
    @State var isEditingAuthor = false
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage.named(author.imageName))
                .resizable()
                .cornerRadius(5)
                .scaledToFit()
                .layoutPriority(1)
            VStack(alignment: .leading) {
                Text(author.name)
                    .fontWeight(.light)
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .kerning(1)
                    .textCase(.uppercase)
                Stars(rating: author.rating)
            }
            // NOTE: Configure higher layoutPriority to give a view more UI real estate.
            .layoutPriority(2)
        }
        .frame(maxHeight: 60)
    }
}

struct BooksByAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        BooksByAuthorView()
            .environmentObject(ReadingListStore())
        BooksByAuthorView()
            .environmentObject(ReadingListStore())
            .preferredColorScheme(.dark)
    }
}
