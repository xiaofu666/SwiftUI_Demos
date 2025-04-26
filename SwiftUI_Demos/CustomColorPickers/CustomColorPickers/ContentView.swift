//
//  ContentView.swift
//  CustomColorPickers
//
//  Created by Xiaofu666 on 2025/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("条形颜色选择器") {
                    ColorBarPicker()
                }
                NavigationLink("圆形颜色选择器") {
                    ColorCircularPicker()
                }
                NavigationLink("多颜色选择") {
                    ColorMultiCirclePicker()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
