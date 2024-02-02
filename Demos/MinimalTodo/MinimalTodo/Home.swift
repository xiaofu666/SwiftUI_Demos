//
//  Home.swift
//  MinimalTodo
//
//  Created by Lurich on 2024/2/2.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private var activeList: [Todo]
    
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) { todo in
                    TodoRowView(todo: todo)
                }
            }
            CompletedTodoList(showAll: $showAll)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    let todo = Todo(task: "", priority: .normal)
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return "Active\(count == 0 ? "" : " \(count)")"
    }
}

#Preview {
    ContentView()
}
