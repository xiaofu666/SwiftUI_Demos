//
//  ContentView.swift
//  PopularMovieContentView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            PopularMovieContentView()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
