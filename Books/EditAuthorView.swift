// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct EditAuthorView: View {
    @Binding var isEditing: Bool
    @ObservedObject var author: Author
    @EnvironmentObject var store: ReadingListStore

    var body: some View {
        NavigationView {
            Form {
                TitledTextFieldCell(title: "Name", placeholder: "Jane Austen", text: $author.name)
                RatingPickerCell(title: "Rating", rating: $author.rating)
                    .padding(.top, 12.0)                
            }
            .navigationBarTitle("Edit Author")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: done, label: { ButtonLabels.done })
                }
            }
        }
    }
    
    private func done() {
        isEditing = false
        store.save()
    }
}

struct EditAuthorView_Previews: PreviewProvider {
    static var store = ReadingListStore()
    static var authorsView = AuthorsView()
    static var previews: some View {
        EditAuthorView(isEditing: authorsView.$isEditingAuthor, author: TestData.author)
    }
}
