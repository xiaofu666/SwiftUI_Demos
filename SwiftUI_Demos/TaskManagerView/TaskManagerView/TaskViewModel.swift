//
//  TaskViewModel.swift
//  TaskManager0505
//
//  Created by Lurich on 2022/5/5.
//

import SwiftUI
import CoreData


class TaskViewModel: ObservableObject {
  
    @Published var currentTab: String = "Today"
    
    //new task properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    //editing existing task data
    @Published var editTask: TaskData?
    
    func addTask(context: NSManagedObjectContext) -> Bool {
        
        //updating existing data in core data
        var task: TaskData!
        if let editTask = editTask {
             
            task = editTask
        } else {
            
            task = TaskData(context: context)
            
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            
            return true
        }
        
        return false
    }
    
    func resetTaskData() {
        
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
        
    }
    
    func setupTask() {
        
        if let editTask = editTask {
            
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}

