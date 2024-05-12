//
//  ContentView.swift
//  PhotosApp
//
//  Created by Lurich on 2024/5/12.
//

import SwiftUI

struct ContentView: View {
    var coordinator: UICoordinator = .init()
    var body: some View {
        Home()
            .environment(coordinator)
    }
}

#Preview {
    ContentView()
}
