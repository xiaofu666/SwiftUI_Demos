//
//  ContentView.swift
//  GradientGenFM
//
//  Created by Xiaofu666 on 2025/6/21.
//

import SwiftUI

struct ContentView: View {
    @State private var colors: [Color] = [.white]
    var body: some View {
        VStack {
            GradientGenerator { palette in
                colors = palette.swiftUIColors
            }
            .padding(15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    ContentView()
}
