//
//  DetailView.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/23.
//

import SwiftUI

struct DetailView: View {
    var size: CGSize
    var titleNoteSize: CGSize
    var animation: Namespace.ID
    @Bindable var note: NoteModel
    @State private var animateLayers: Bool = false
    
    var body: some View {
        Rectangle()
            .fill(note.color.gradient)
            .overlay(alignment: .topLeading) {
                TitleNoteView(size: titleNoteSize, note: note)
                    .blur(radius: animateLayers ? 100 : 0)
                    .opacity(animateLayers ? 0 : 1)
            }
            .overlay {
                NotesContent()
            }
            .clipShape(.rect(cornerRadius: animateLayers ? 0 : 10))
            .matchedGeometryEffect(id: note.id, in: animation)
            .transition(.offset(y: 1))
            .allowsTightening(note.allowsHitTesting)
            .onChange(of: note.allowsHitTesting, initial: true) { oldValue, newValue in
                withAnimation(noteAnimation) {
                    animateLayers = newValue
                }
            }
    }
    
    @ViewBuilder
    func NotesContent() -> some View {
        GeometryReader {
            VStack(alignment: .leading, spacing: 10) {
                TextField("Title", text: $note.title, axis: .vertical)
                    .font(.title)
                    .lineLimit(2)
                
                TextEditor(text: $note.content)
                    .font(.title3)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .overlay(alignment: .topLeading) {
                        if note.content.isEmpty {
                            Text("Add a note...")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .offset(x: 8, y: 8)
                        }
                    }
            }
            .tint(.black)
            .padding(15)
            .padding(.top, safeArea.top)
            .frame(width: size.width - 30, height: size.height)
            .frame(width: $0.size.width, height: $0.size.height, alignment: .topLeading)
        }
        .blur(radius: animateLayers ? 0 : 100)
        .opacity(animateLayers ? 1 : 0)
    }
    
    var safeArea: UIEdgeInsets {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
    }
}

#Preview {
    ContentView()
}
