//
//  SearchQueryView.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/26.
//

import SwiftUI
import SwiftData

struct SearchQueryView<Content: View>: View {
    init(searchText: String, @ViewBuilder content: @escaping ([NoteModel]) -> Content) {
        self.content = content
        
        let predicate = #Predicate<NoteModel>{ input in
            return searchText.isEmpty || input.title.localizedStandardContains(searchText)
        }
        _notes = .init(filter: predicate, sort: [.init(\.dateCreated, order: .reverse)], animation: .snappy)
    }
    
    var content: ([NoteModel]) -> Content
    @Query var notes: [NoteModel]
    
    var body: some View {
        content(notes)
    }
}

#Preview {
    ContentView()
}
