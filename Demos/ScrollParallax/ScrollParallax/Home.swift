//
//  Home.swift
//  ScrollParallax
//
//  Created by Lurich on 2023/12/28.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummySection(title: "Social Media")
                
                DummySection(title: "Sales", isLong: true)
                
                ParallaxImageView(usesFullWidth: true) { size in
                    Image(.user1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                DummySection(title: "Business", isLong: true)
                
                DummySection(title: "Promotion", isLong: true)
                
                ParallaxImageView(maximumMovement: 150, usesFullWidth: false) { size in
                    Image(.user1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 450)
                
                DummySection(title: "YouTube")
                
                DummySection(title: "Apple")
                
                DummySection(title: "Twitter (X)", isLong: true)
            }
            .padding(15)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title.bold())
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dlummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book.\(isLong ? "It has survived not only five centuries, but also the leap into electronic typesetting,remaining essentially unchanged." : "")")
                .multilineTextAlignment(.leading)
                .kerning(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
