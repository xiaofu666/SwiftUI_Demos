//
//  TitleNoteView.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/26.
//

import SwiftUI

struct TitleNoteView: View {
    var size: CGSize
    var note: NoteModel
    
    var body: some View {
        Text(note.title)
            .font(.title3)
            .fontWeight(.medium)
            .foregroundStyle(.black)
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .frame(width: size.width, height: size.height)
    }
}

#Preview {
    ContentView()
}
