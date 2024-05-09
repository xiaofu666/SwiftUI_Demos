//
//  DummyContent.swift
//  PinterestGridAnimation
//
//  Created by Lurich on 2024/5/9.
//

import SwiftUI

struct DummyContent: View{
    var body: some View {
        LazyVStack(spacing: 15) {
            DummySection(title: "Social Media")
            DummySection(title:"Sales", isLong: true)
            /// Image
            ImageView("Pic 1")
            DummySection(title: "Busniess",isLong: true)
            DummySection(title: "Promotion",isLong: true)
            /// Image
            ImageView("Pic 2")
            DummySection(title: "YouTube")
            DummySection(title: "Twitter (X)")
            DummySection(title:"Marketing Campaign",isLong: true)
            ImageView("Pic 3")
            DummySection(title:"Conclusion", isLong: true)
            
        }
        .padding(15)
    }
    /// Dummy Section
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View {
        VStack(alignment:.leading,spacing:8, content: {
            Text(title)
                .font(.title.bold( ))
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\(isLong ? "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged." : "")")
                .multilineTextAlignment(.leading)
                .kerning(1.2)
        })
        .frame(maxWidth: .infinity, alignment:.leading)
    }
    @ViewBuilder
    func ImageView(_ image: String) -> some View {
        GeometryReader {
            let size = $0.size
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width,height: size.height)
                .clipped()
        }
        .frame(height: 400)
    }
}
    
#Preview {
    DummyContent()
}
