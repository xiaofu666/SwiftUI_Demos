//
//  DragDropLists.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/18.
//

import SwiftUI

struct DragDropLists: View {
    /// Sample Tasks
    @State private var todo: [DragDropModel] = [
        .init(title: "Edit Video!", status: .todo)
    ]
    @State private var working: [DragDropModel] = [
        .init(title: "Record Video", status: .working)
    ]
    @State private var completed: [DragDropModel] = [
        .init(title: "Implement Drag & Drop", status: .completed),
        .init(title: "Update Mockview App!", status: .completed),
    ]
    
    @State private var currentlyDragging: DragDropModel?
    var body: some View {
        HStack(spacing: 2, content: {
            TodoView()
            
            WorkingView()
            
            CompletedView()
        })
    }
    
    @ViewBuilder
    func TaskView(_ tasks: [DragDropModel]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(tasks) { task in
                GeometryReader(content: { geometry in
                    TaskRowView(task, geometry.size)
                })
                .frame(height: 45)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    func TaskRowView(_ task: DragDropModel, _ size: CGSize) -> some View {
        Text(task.title)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .background(.white, in: .rect(cornerRadius: 10))
            .contentShape(.dragPreview, .rect(cornerRadius: 10))
            .draggable(task.id.uuidString) {
                Text(task.title)
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: size.height)
                    .background(.white, in: .rect(cornerRadius: 10))
                    .contentShape(.dragPreview, .rect(cornerRadius: 10))
                    .onAppear() {
                        currentlyDragging = task
                    }
            }
            .dropDestination(for: String.self) { items, location in
                currentlyDragging = nil
                return false
            } isTargeted: { status in
                withAnimation(.snappy) {
                    if let currentlyDragging, status, currentlyDragging.id != task.id {
                        appendTask(task.status)
                        
                        switch task.status {
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .working:
                            replaceItem(tasks: &working, droppingTask: task, status: .working)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }
                    }
                }
            }
    }
    
    func appendTask(_ status: Status) {
        if let currentlyDragging {
            switch status {
            case .todo:
                if !todo.contains(where: { $0.id == currentlyDragging.id }) {
                    var updateTask = currentlyDragging
                    updateTask.status = .todo
                    todo.append(updateTask)
                    
                    working.removeAll(where: { $0.id == currentlyDragging.id })
                    completed.removeAll(where: { $0.id == currentlyDragging.id })
                }
            case .working:
                if !working.contains(where: { $0.id == currentlyDragging.id }) {
                    var updateTask = currentlyDragging
                    updateTask.status = .working
                    working.append(updateTask)
                    
                    todo.removeAll(where: { $0.id == currentlyDragging.id })
                    completed.removeAll(where: { $0.id == currentlyDragging.id })
                }
            case .completed:
                if !completed.contains(where: { $0.id == currentlyDragging.id }) {
                    var updateTask = currentlyDragging
                    updateTask.status = .completed
                    completed.append(updateTask)
                    
                    working.removeAll(where: { $0.id == currentlyDragging.id })
                    todo.removeAll(where: { $0.id == currentlyDragging.id })
                }
            }
        }
    }
    
    func replaceItem(tasks: inout [DragDropModel], droppingTask: DragDropModel, status: Status) {
        if let currentlyDragging, let sourceIndex = tasks.firstIndex(where: { $0.id == currentlyDragging.id }), let destinationIndex = tasks.firstIndex(where: { $0.id == droppingTask.id }) {
            var sourceItem = tasks.remove(at: sourceIndex)
            sourceItem.status = status
            tasks.insert(sourceItem, at: destinationIndex)
        }
    }
    
    @ViewBuilder
    func TodoView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(todo)
            }
            .navigationTitle("Todo")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                withAnimation(.snappy) {
                    appendTask(.todo)
                }
                return true
            }
        }
    }
    
    @ViewBuilder
    func WorkingView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(working)
            }
            .navigationTitle("Working")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                withAnimation(.snappy) {
                    appendTask(.working)
                }
                return true
            }
        }
    }
    
    @ViewBuilder
    func CompletedView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(completed)
            }
            .navigationTitle("Completed")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                withAnimation(.snappy) {
                    appendTask(.completed)
                }
                return true
            }
        }
    }
}

#Preview {
    DragDropLists()
}


struct DragDropModel: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var status: Status
}

enum Status {
    case todo
    case working
    case completed
}

