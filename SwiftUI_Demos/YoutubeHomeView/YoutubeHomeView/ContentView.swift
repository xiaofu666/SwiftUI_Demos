//
//  ContentView.swift
//  YoutubeHomeView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 18.0, *) {
            YoutubeHomeView2()
        } else {
            YoutubeHomeView1()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
