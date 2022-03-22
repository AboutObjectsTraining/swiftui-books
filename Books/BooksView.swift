// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct BooksView: View {
    @ObservedObject var author: Author
    var body: some View {
        List {
            AuthorImage(author: author)
            ForEach(author.books) { book in
                BookSummaryCell(book: book, font: Configuration.Cell.Title.font)
                    .frame(maxHeight: Configuration.Cell.maxHeight)
            }
        }
        .navigationBarTitle(author.name)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BooksView(author: TestData.author)
        }
        NavigationView {
            BooksView(author: TestData.author)
        }
        .preferredColorScheme(.dark)
    }
}

struct BookSummaryCell: View {
    @State var isEditing = false
    @ObservedObject var book: Book
    let font: Font
    
    var body: some View {
        HStack {
            Image(book.title)
                .resizable()
                .scaledToFit()
                .layoutPriority(1)
            VStack(alignment: .leading, spacing: Configuration.Cell.spacing) {
                Text(book.title)
                    .font(font)
                    .fontWeight(Configuration.Cell.Title.weight)
                    .foregroundColor(Configuration.Cell.Title.color)
                Text(book.year?.description ?? "----")
                    .foregroundColor(Configuration.Cell.Year.color)
                    .padding(.top, Configuration.Cell.Year.padding)
                Stars(rating: book.rating)
            }
            .layoutPriority(1)
            Spacer()
            Button(action: { isEditing = true }, label: { ButtonLabels.info })
                .padding(.horizontal, Configuration.Cell.Button.padding)
                .sheet(isPresented: $isEditing,
                       content: { EditBookView(isEditing: $isEditing, book: book) })
        }
    }
}

struct AuthorImage: View {
    @ObservedObject var author: Author
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Circle()
                .frame(height: Configuration.Circle.height)
                .foregroundColor(Configuration.Circle.color)
                .overlay(
                    Image(author.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: Configuration.AuthorImage.imageHeight)
                        .mask(Circle()))
            
            Spacer()
        }
        .frame(height: Configuration.AuthorImage.height)
    }
}

fileprivate struct Configuration {
    struct Cell {
        static let maxHeight: CGFloat = 120
        static let spacing: CGFloat = 2
        struct Title {
            static let font: Font = .title3
            static let weight: Font.Weight = .semibold
            static let color: Color = .primary
        }
        struct Year {
            static let color: Color = .secondary
            static let padding: CGFloat = 4
        }
        struct Button {
            static let padding: CGFloat = 4
        }
    }
    struct AuthorImage {
        static let height: CGFloat = 160
        static let imageHeight: CGFloat = 140
    }
    struct Circle {
        static let height: CGFloat = 148
        static let color = Color.gray
    }
}
