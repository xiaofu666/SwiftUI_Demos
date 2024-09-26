//
//  HomeView.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/23.
//

import SwiftUI

struct Home: View {
    @State private var searchText: String = ""
    @State private var selectedNote: NoteModel?
    @State private var deleteNote: NoteModel?
    @State private var animateView: Bool = false
    @FocusState private var isKeyboardActive: Bool
    @State private var titleNoteSize: CGSize = .zero
    @Namespace private var animation
    @Environment(\.modelContext) private var context
    
    var body: some View {
        SearchQueryView(searchText: searchText) { notes in
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    SearchBar()
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                        ForEach(notes) { note in
                            CardView(note)
                                .frame(height: 160)
                                .onTapGesture {
                                    guard selectedNote == nil else { return }
                                    isKeyboardActive = false
                                    selectedNote = note
                                    note.allowsHitTesting = true
                                    withAnimation(noteAnimation) {
                                        animateView = true
                                    }
                                }
                        }
                    }
                }
            }
            .safeAreaPadding(10)
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    ForEach(notes) { note in
                        if note.id == selectedNote?.id && animateView {
                            DetailView(
                                size: size,
                                titleNoteSize: titleNoteSize,
                                animation: animation,
                                note: note
                            )
                            .ignoresSafeArea(.container, edges: .top)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                BottomBar()
            }
            .focused($isKeyboardActive)
        }
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
            
            TextField("Search", text: $searchText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(.primary.opacity(0.06), in: .rect(cornerRadius: 10))
    }
    
    @ViewBuilder
    func CardView(_ note: NoteModel) -> some View {
        ZStack {
            if selectedNote?.id == note.id && animateView {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(note.color.gradient)
                    .overlay {
                        TitleNoteView(size: titleNoteSize, note: note)
                    }
                    .matchedGeometryEffect(id: note.id, in: animation)
            }
        }
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            titleNoteSize = newValue
        }

    }
    
    @ViewBuilder
    func BottomBar() -> some View {
        HStack(spacing: 15) {
            Button {
                if selectedNote == nil {
                    createEmptyNote()
                } else {
                    selectedNote?.allowsHitTesting = false
                    deleteNote = selectedNote
                    closeNote()
                }
            } label: {
                Image(systemName: selectedNote == nil ? "plus.circle.fill" : "trash.fill")
                    .font(.title2)
                    .foregroundStyle(selectedNote == nil ? Color.primary : .red)
                    .contentShape(.rect)
                    .contentTransition(.symbolEffect(.replace))
            }
            .opacity(isKeyboardActive ? 0 : 1)
            
            Spacer(minLength: 0)
            
            if selectedNote != nil, !isKeyboardActive {
                Button {
                    selectedNote?.allowsHitTesting = false
                    
                    if let selectedNote, (selectedNote.title.isEmpty && selectedNote.content.isEmpty) {
                        deleteNote = selectedNote
                    }
                    
                    closeNote()
                } label: {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .contentShape(.rect)
                }
            } else if isKeyboardActive {
                Button("Done") {
                    isKeyboardActive = false
                }
                .font(.title3)
                .foregroundStyle(.primary)
            }
        }
        .transition(.blurReplace)
        .overlay {
            Text("Notes")
                .font(.callout)
                .fontWeight(.semibold)
                .opacity(selectedNote != nil ? 0 : 1)
        }
        .overlay {
            if selectedNote != nil, !isKeyboardActive {
                CardColorPickerView()
                    .transition(.blurReplace)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, isKeyboardActive ? 8 : 15)
        .background(.bar)
        .animation(noteAnimation, value: selectedNote != nil)
        .animation(noteAnimation, value: isKeyboardActive)
    }
    
    @ViewBuilder
    func CardColorPickerView() -> some View {
        HStack(spacing: 10) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .fill(Color("Note \(index)"))
                    .frame(width: 20)
                    .contentShape(.circle)
                    .onTapGesture {
                        withAnimation(noteAnimation) {
                            selectedNote?.colorString = "Note \(index)"
                        }
                    }
            }
        }
    }
    
    func createEmptyNote() {
        let colors: [String] = (1...5).compactMap({ "Note \($0)" })
        if let randomColor = colors.randomElement() {
            let NoteModel: NoteModel = .init(colorString: randomColor, title: "", content: "")
            context.insert(NoteModel)
            DispatchQueue.main.async {
                selectedNote = NoteModel
                selectedNote?.allowsHitTesting = true
                withAnimation(noteAnimation) {
                    animateView = true
                }
            }
        } else {
            print("异常")
        }
    }
    func closeNote() {
        withAnimation(noteAnimation.logicallyComplete(after: 0.1), completionCriteria: .logicallyComplete) {
            selectedNote = nil
            animateView = false
        } completion: {
            deleteNoteFromContext()
        }
    }
    func deleteNoteFromContext() {
        if let deleteNote {
            context.delete(deleteNote)
            try? context.save()
            self.deleteNote = nil
        }
    }
}

extension View {
    var noteAnimation: Animation {
        .smooth(duration: 0.3)
    }
}

#Preview {
    ContentView()
}
