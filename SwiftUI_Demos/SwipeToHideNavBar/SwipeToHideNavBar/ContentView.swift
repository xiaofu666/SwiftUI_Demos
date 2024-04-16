//
//  ContentView.swift
//  SwipeToHideNavBar
//
//  Created by Lurich on 2023/9/13.
//

import SwiftUI

struct ContentView: View {
    @State private var hideNavBar: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...50, id: \.self) { index in
                    NavigationLink {
                        List {
                            ForEach(1...50, id: \.self) { index in
                                Text("List Item \(index)")
                            }
                        }
                        .listStyle(.plain)
                        .navigationTitle("Detail View")
                    } label: {
                        Text("List Item \(index)")
                    }

                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat App")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        hideNavBar.toggle()
                    }, label: {
                        Image(systemName: hideNavBar ? "eye.slash" : "eye")
                    })
                }
            })
            .hideNavBarOnSwipe(hideNavBar)
        }
    }
}

#Preview {
    ContentView()
}
