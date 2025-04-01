//
//  ContentView.swift
//  AlertDrawer
//
//  Created by Xiaofu666 on 2025/4/1.
//

import SwiftUI

struct ContentView: View {
    @State private var config: DrawerConfig = .init()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                DrawerButton(config: $config)
            }
            .padding()
            .navigationTitle("Alert Drawer")
            .alertDrawer(config: $config) {
                return false
            } onSecondaryClick: {
                return true
            } content: {
                ///Dummy Content
                VStack(alignment: .leading, spacing: 15) {
                    Image(systemName:"exclamationmark.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Are you sure?")
                        .font(.title2.bold())
                    
                    Text("You haven't backed up your wallet yet.\nIf you remove it, you could lose access forever. We suggest tapping Cancel and backing up your wallet first with a valid recovery method.")
                        .foregroundStyle(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 300)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
