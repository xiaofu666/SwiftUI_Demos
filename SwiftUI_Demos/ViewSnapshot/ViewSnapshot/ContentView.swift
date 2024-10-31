//
//  ContentView.swift
//  ViewSnapshot
//
//  Created by Xiaofu666 on 2024/10/31.
//

import SwiftUI

struct ContentView: View {
    @State private var trigger: Bool = false
    @State private var snapshot: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...20, id: \.self) {
                    Text("List Cell \($0)")
                }
            }
            .navigationTitle("List View")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Snapshot") {
                        trigger.toggle()
                    }
                }
            }
        }
        .snapshot(trigger: trigger) { uiImage in
            snapshot = uiImage
        }
        .ignoresSafeArea()
        .overlay {
            if let snapshot {
                Image(uiImage: snapshot)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    .padding(15)
                    .shadow(radius: 10)
                    .onTapGesture {
                        self.snapshot = nil
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
