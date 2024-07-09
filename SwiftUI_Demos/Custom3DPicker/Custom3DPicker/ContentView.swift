//
//  ContentView.swift
//  Custom3DPicker
//
//  Created by Lurich on 2024/7/9.
//

import SwiftUI

struct ContentView: View {
    let pickerValues: [String] = [
    "SwiftUI", "UIKit", "AVKit", "WidgetKit", "LiveActivities", "CoreImage", "AppIntents"
    ]
    let pickerValues1: [String] = [
    "i0S 17+ Projects","iOS 16+ Projects", "iOS 18+ Projects", "macOS 13+ Projects", "visionOS 1.0+ Projects"]

    
    @State private var config: PickerConfig = .init(text: "SwiftUI")
    @State private var config1: PickerConfig = .init(text: "iOS 18+ Projects")
    
    var body: some View {
        NavigationStack {
            List {
                Section("Configuration") {
                    Button {
                        config.show.toggle()
                    } label: {
                        HStack {
                            Text("Framework")
                                .foregroundStyle(.gray)
                            Spacer(minLength: 0)
                            SourcePickerView(config: $config)
                        }
                    }
                    Button {
                        config1.show.toggle()
                    } label: {
                        HStack {
                            Text("Projects")
                                .foregroundStyle(.gray)
                            Spacer(minLength: 0)
                            SourcePickerView(config: $config1)
                        }
                    }
                }
            }
            .navigationTitle("Custom Picker")
        }
        .customPicker($config, items: pickerValues)
        .customPicker($config1, items: pickerValues1)
    }
}

#Preview {
    ContentView()
}
