// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct AddAuthorView: View {
    @StateObject var author = Author(name: "", books: [])
    @EnvironmentObject var store: ReadingListStore
    
    @Binding var isAddingAuthor: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TitledTextFieldCell(title: "Name", placeholder: "Jane Austen", text: $author.name)
                RatingPickerCell(title: "Rating", rating: $author.rating)
            }
            .navigationBarTitle("Add Author")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: cancel, label: { Text("Cancel") })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addAuthor, label: { Text("Done") })
                }
            }
        }
    }
    
    private func addAuthor() {
        store.addAuthor(author)
        isAddingAuthor = false
    }
    
    private func cancel() {
        isAddingAuthor = false
    }
}

struct RatingPickerCell: View {
    let title: String
    @Binding var rating: Rating
    
    var body: some View {
        Picker("Rating", selection: $rating) {
            ForEach(Rating.allCases) { rating in
                Stars(rating: rating)
                    .tag(rating)
            }
        }
        .foregroundColor(.secondary)
        .pickerStyle(.automatic)
        .padding(8.0)
    }
}

struct TitledTextFieldCell: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Group {
                Text(title)
                    .frame(width: 60)
                    .foregroundColor(.secondary)
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.vertical, 8.0)
        }
    }
}

struct AddAuthorView_Previews: PreviewProvider {
    static var store = ReadingListStore()
    static var authorsView = AuthorsView()
    static var previews: some View {
        AddAuthorView(isAddingAuthor: authorsView.$isAddingAuthor)
    }
}

