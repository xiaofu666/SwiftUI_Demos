//
//  AddTaskView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI
import CoreData

@available(iOS 16.0, *)
struct AddTaskView: View {
//    var onAdd: (TaskModel) -> ()
    
    @Environment(\.managedObjectContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    @State private var taskName: String = ""
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskCategory: Category = .general
    ///animation color
    @State private var animateColor: Color = Category.general.color
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                }
                
                Text("Create New Task")
                    .ubuntu(28, .light)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                
                TitleName("NAME")
                
                TextField("Make New Video", text: $taskName)
                    .ubuntu(16, .regular)
                    .tint(.white)
                    .padding(.top, 2)
                
                Rectangle()
                    .fill(.white.opacity(0.7))
                    .frame(height: 1)
                
                
                TitleName("DATE")
                    .padding(.top, 15)
                
                HStack(alignment: .bottom, spacing: 12) {
                    HStack(spacing: 12) {
                        Text(taskDate.toString("EEEE dd, MMMM"))
                            .ubuntu(16, .regular)
                        
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.date])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                    
                    
                    HStack(spacing: 12) {
                        Text(taskDate.toString("hh:mm a"))
                            .ubuntu(16, .regular)
                        
                        Image(systemName: "clock")
                            .font(.title)
                            .foregroundColor(.white)
                            .overlay {
                                DatePicker("", selection: $taskDate, displayedComponents: [.hourAndMinute])
                                    .blendMode(.destinationOver)
                            }
                    }
                    .offset(y: -5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(.white.opacity(0.7))
                            .frame(height: 1)
                            .offset(y: 5)
                    }
                }
                .padding(.bottom, 15)

            }
            .environment(\.colorScheme, .dark)
            .hAligm(.leading)
            .padding(15)
            .background{
                ZStack {
                    taskCategory.color
                    
                    GeometryReader { proxy in
                        let size = proxy.size
                        Rectangle()
                            .fill(animateColor)
                            .mask{
                                Circle()
                            }
                            .frame(width: animate ? size.width * 2 : 0, height: animate ? size.width * 2 : 0)
                            .offset(animate ? CGSize(width: -size.width / 2, height: -size.height / 2) : size)
                    }
                    .clipped()
                }
                .ignoresSafeArea()
            }
            
            VStack(alignment: .leading) {
                TitleName("DESCRIPTTION", .gray)
                
                TextField("About Your Task", text: $taskDescription)
                    .ubuntu(16, .regular)
                    .padding(.top, 3)
                
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 1)
                
                TitleName("CATEGORY", .gray)
                    .padding(.top, 15)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 20), count: 3), spacing: 15) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue.uppercased())
                            .ubuntu(17, .regular)
                            .hAligm(.center)
                            .padding(.vertical, 5)
                            .background {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(category.color.opacity(0.25))
                            }
                            .foregroundColor(category.color)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                guard !animate else { return }
                                animateColor = category.color
                                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1, blendDuration: 1)) {
                                    animate = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    animate = false
                                    taskCategory = category
                                }
                            }
                    }
                }
                .padding(.top, 5)
                
                Button {
                    let task = TaskModel(dateAdded: taskDate, taskName: taskName, taskDescription: taskDescription, taskCategory: taskCategory)
//                    onAdd(task)
                    addExpense(task)
                    dismiss()
                } label: {
                    Text("Create Task")
                        .ubuntu(16, .regular)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .hAligm(.center)
                        .background {
                            Capsule()
                                .fill(animateColor.gradient)
                        }
                }
                .vAligm(.bottom)
                .disabled(taskName == "" || animate)
                .opacity(taskName == "" ? 0.6 : 1)

            }
            .padding(15)
        }
        .vAligm(.top)
    }
    
    @ViewBuilder
    func TitleName(_ value: String, _ color: Color = .white.opacity(0.7)) -> some View {
        Text(value)
            .ubuntu(12, .regular)
            .foregroundColor(color)
    }
    
    func addExpense(_ task: TaskModel) {
        do {
            let coreData = TaskManagerData(context: context)
            coreData.id = task.id
            coreData.taskName = task.taskName
            coreData.taskDescription = task.taskDescription
            coreData.dateAdded = task.dateAdded
            coreData.taskCategory = task.taskCategory.rawValue
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

@available(iOS 16.0, *)
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
