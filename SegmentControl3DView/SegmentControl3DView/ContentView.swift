//
//  ContentView.swift
//  SegmentControl3DView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            DetailView()
                .navigationBarTitle("3D 分段选择器")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
