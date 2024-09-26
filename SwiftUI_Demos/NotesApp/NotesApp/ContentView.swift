//
//  ContentView.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .modelContainer(for: NoteModel.self)
    }
}

#Preview {
    ContentView()
}
