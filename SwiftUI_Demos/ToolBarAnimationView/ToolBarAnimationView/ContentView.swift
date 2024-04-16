//
//  ContentView.swift
//  ToolBarAnimationView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ToolBarAnimation()
                .navigationTitle("Tool Bar")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
