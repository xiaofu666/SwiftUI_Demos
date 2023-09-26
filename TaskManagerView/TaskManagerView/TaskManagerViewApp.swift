//
//  TaskManagerViewApp.swift
//  TaskManagerView
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

@main
struct TaskManagerViewApp: App {
    let persistenceController = TaskManagerViewPersistence.shared
    
    var body: some Scene {
        WindowGroup {
            TaskManagerView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
