// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct AuthorsView: View {
    @EnvironmentObject var store: ReadingListStore
    @State var isAddingAuthor = false
    @State var isEditingAuthor = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.authors) { author in
                    AuthorCell(author: author)
                }
            }
            .navigationBarTitle("Authors")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addAuthor, label: { ButtonLabels.plus })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $isAddingAuthor,
               content: { AddAuthorView(isAddingAuthor: $isAddingAuthor) })
    }
    
    func addAuthor() {
        isAddingAuthor = true
    }
}

struct AuthorCell: View {
    @ObservedObject var author: Author
    @State var isEditingAuthor = false
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage.named(author.imageName))
                .resizable()
                .cornerRadius(5)
                .scaledToFit()
                .layoutPriority(1)
                .frame(maxHeight: 60)
            VStack(alignment: .leading) {
                Text(author.name)
                    .fontWeight(.light)
                    .foregroundColor(.primary)
                    .font(.subheadline)
                    .kerning(1)
                    .textCase(.uppercase)
                Stars(rating: author.rating)
            }
            .layoutPriority(2)
            
            Spacer()
            Image(systemName: isEditingAuthor ? "info.circle.fill" : "info.circle")
                .foregroundColor(.blue)
                .padding(.leading)
                .onTapGesture { isEditingAuthor.toggle() }
                .sheet(isPresented: $isEditingAuthor,
                       content: { EditAuthorView(isEditing: $isEditingAuthor, author: author) })
            
            NavigationLink(destination: BooksView(author: author)) {
                EmptyView()
            }
            .fixedSize()
        }
    }
}

struct Stars: View {
    let rating: Rating
    
    var body: some View {
        Text(rating.stars)
            .foregroundColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorCell(author: TestData.author)
        AuthorsView()
            .environmentObject(TestData.store)
    }
}
