//
//  ContentView.swift
//  CustomDropDown
//
//  Created by Xiaofu666 on 2024/7/15.
//

import SwiftUI

var pickerValues: [String] = ["YouTube", "Instagram", "X（Twitter）", "Snapchat", "TikTok", "Telegram"]
struct ContentView: View {
    @State private var config: DropdownConfig = .init(activeText: "YouTube")
    
    var body: some View {
        NavigationStack {
            List {
                SourceDropdownView(config: $config)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationTitle("Dropdown View")
        }
        .dropdownOverlay($config, values: pickerValues, allShow: false)
    }
}

#Preview {
    ContentView()
}
