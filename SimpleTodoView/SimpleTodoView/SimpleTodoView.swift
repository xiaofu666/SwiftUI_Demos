//
//  SimpleTodoView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/6/10.
//

import SwiftUI

@available(iOS 16.0, *)
struct SimpleTodoView: View {
    @Environment(\.self) private var env
    @State private var filterDate: Date = .init()
    @State private var showPendingTasks: Bool = true
    @State private var showCompletedTasks: Bool = true
    
    var body: some View {
        List {
            DatePicker(selection: $filterDate, displayedComponents: .date) {
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            DisclosureGroup(isExpanded: $showPendingTasks) {
                CustomFilteringDataView(displayPendingTask: true, filterDate: filterDate) { task in
                    TaskRow(task: task, isPending: true)
                }
            } label: {
                Text("Pending Task's")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                CustomFilteringDataView(displayPendingTask: false, filterDate: filterDate) { task in
                    TaskRow(task: task, isPending: false)
                }
            } label: {
                Text("Complete Task's")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("To-Do")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    do {
                        let task = SimpleTodoTask(context: env.managedObjectContext)
                        task.id = .init()
                        task.date = filterDate
                        task.title = ""
                        task.isCompleted = false
                        
                        try env.managedObjectContext.save()
                        showPendingTasks = true
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        
                        Text("New Task")
                    }
                    .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
        }
    }
}

@available(iOS 16.0, *)
struct SimpleTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SimpleTodoView()
        }
    }
}

@available(iOS 16.0, *)
struct TaskRow: View {
    @ObservedObject var task: SimpleTodoTask
    var isPending: Bool
    
    @Environment(\.self) private var env
    @FocusState private var showKeyBoard: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                task.isCompleted.toggle()
                save()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                TextField("Task Title", text: .init(get: {
                    return task.title ?? ""
                }, set: { value in
                    task.title = value
                }))
                .focused($showKeyBoard)
                .onSubmit {
                    removeEmptyTask()
                    save()
                }
                .foregroundColor(isPending ? .primary : .gray)
                .strikethrough(!isPending, pattern: .dash, color: .primary)
                
                Text((task.date ?? .init()).formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .foregroundColor(.gray)
                    .overlay {
                        DatePicker("", selection: .init(get: {
                            return task.date ?? .init()
                        }, set: { date in
                            task.date = date
                            save()
                        }), displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .blendMode(.destinationOver)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear() {
            if (task.title ?? "").isEmpty {
                showKeyBoard = false
            }
        }
        .onDisappear() {
            removeEmptyTask()
            save()
        }
        .onChange(of: env.scenePhase) { oldValue,newValue in
            if newValue != .active {
                showKeyBoard = false
                DispatchQueue.main.async {
                    removeEmptyTask()
                    save()
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    env.managedObjectContext.delete(task)
                    save()
                }
            } label: {
                Image(systemName: "trash.fill")
            }

        }
    }
    
    func save() {
        do {
            try env.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeEmptyTask() {
        if (task.title ?? "").isEmpty {
            env.managedObjectContext.delete(task)
        }
    }
}
