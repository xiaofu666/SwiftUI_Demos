//
//  SimpleTodoViewApp.swift
//  SimpleTodoView
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

@main
struct SimpleTodoViewApp: App {
    let persistenceController = SimpleTodoViewTaskManagerPersistence.shared
    
    var body: some Scene {
        WindowGroup {
            SimpleTodoView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
