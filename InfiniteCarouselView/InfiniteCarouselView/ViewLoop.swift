//
//  ViewLoop.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/23.
//

import SwiftUI

@available(iOS 14.0, *)
struct ViewLoop: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var index = 0
    var body: some View {
        VStack {
            TabView(selection: $index) {
                ForEach (1..<6) { i in
                    Image("Book \(i)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation {
                    index = index < 5 ? index + 1 : 0
                }
            }
        }.ignoresSafeArea()
    }
}

@available(iOS 14.0, *)
struct ViewLoop_Previews: PreviewProvider {
    static var previews: some View {
        ViewLoop()
    }
}
