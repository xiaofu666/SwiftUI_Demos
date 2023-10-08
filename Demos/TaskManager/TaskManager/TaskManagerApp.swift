//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = TaskManagerPersistence.shared
    
    var body: some Scene {
        WindowGroup {
            TaskManager()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
