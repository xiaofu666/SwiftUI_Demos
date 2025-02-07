//
//  FlashCardsApp.swift
//  FlashCards
//
//  Created by Xiaofu666 on 2025/2/7.
//

import SwiftUI

@main
struct FlashCardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
