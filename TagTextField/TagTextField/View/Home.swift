//
//  Home.swift
//  TagTextField
//
//  Created by Lurich on 2023/9/14.
//

import SwiftUI

struct Home: View {
    @State private var tags: [Tag] = []
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    TagField(tags: $tags)
                    
                    Text("Input tags separated by comma(,)")
                }
                .padding()
            }
            .navigationTitle("Tag Field")
        }
    }
}

#Preview {
    Home()
}
