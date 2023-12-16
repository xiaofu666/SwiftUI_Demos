//
//  Settings.swift
//  Expense Tracker
//
//  Created by Lurich on 2023/12/16.
//

import SwiftUI

struct Settings: View {
    @AppStorage(.userName) private var userName: String = ""
    @AppStorage(.isAppLockEnabled) private var isAppLockEnabled: Bool = false
    @AppStorage(.lockWhenAppGoesBackground) private var lockWhenAppGoesBackground: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("User Name") {
                    TextField("Xiaofu", text: $userName)
                }
                
                Section("App Lock") {
                    Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                    
                    if isAppLockEnabled {
                        Toggle("Lock When App Goes Background", isOn: $lockWhenAppGoesBackground)
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    Settings()
}
