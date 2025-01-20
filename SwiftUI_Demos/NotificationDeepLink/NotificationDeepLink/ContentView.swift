//
//  ContentView.swift
//  NotificationDeepLink
//
//  Created by Xiaofu666 on 2025/1/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppData.self) private var appData
    var body: some View {
        @Bindable var appData = appData
        NavigationStack(path: $appData.mainPageNavigationPath) {
            List {
                NavigationLink("View 1", value: "View1")
                NavigationLink("View 2", value: "View2")
                NavigationLink("View 3", value: "View3")
            }
            .navigationTitle("Notification Deep Link")
            .navigationDestination(for: String.self) { value in
                Text("Hello From \(value)")
                    .navigationTitle(value)
            }
        }
        .task {
            let _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert])
        }
    }
}

#Preview {
    ContentView()
}
