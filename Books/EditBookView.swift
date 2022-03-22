// Copyright (C) 2020 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

extension Optional where Wrapped == Int {
    var text: String {
        get {
            guard let text = self else { return "" }
            return text.description
        }
        set {
            guard let value = Int(newValue) else { self = .none; return }
            self = .some(value) }
    }
}

struct EditBookView: View {
    @Binding var isEditing: Bool
    @ObservedObject var book: Book
    @EnvironmentObject var store: ReadingListStore
    
    var body: some View {
        NavigationView {
            Form {
                TitledTextFieldCell(title: "Title", placeholder: "The Tempest", text: $book.title)
                TitledTextFieldCell(title: "Year", placeholder: "1999", text: $book.year.text)
                RatingPickerCell(title: "Rating", rating: $book.rating)
                    .padding(.leading, 6.0)
                    .padding(.top, 12.0)
            }
            .navigationBarTitle("Edit Book")
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

struct EditBookView_Previews: PreviewProvider {
    @State static var isEditing = true
    static var store = ReadingListStore()
    static var previews: some View {
        NavigationView {
            EditBookView(isEditing: $isEditing, book: TestData.book)
        }
    }
}
