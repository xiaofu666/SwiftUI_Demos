//
//  ContentView.swift
//  LoopingCards
//
//  Created by Xiaofu666 on 2024/12/18.
//

import SwiftUI

struct ImageModel: Identifiable {
    var id: String = UUID().uuidString
    var altText: String
    var image: String
}

let images: [ImageModel] = (0...8).map { index in
    ImageModel(altText: "\(index)", image: "Profile \(index)")
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                LoopingStack {
                    ForEach(images) { item in
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250, height:400)
                            .clipShape(.rect(cornerRadius: 30))
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 35)
                                    .fill(.background)
                            }
                        
                    }
                }
            }
            .navigationTitle("Looping Stack")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.2))
        }
    }
}

#Preview {
    ContentView()
}
