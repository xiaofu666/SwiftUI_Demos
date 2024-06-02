//
//  ContentView2.swift
//  FlipClockAnimation
//
//  Created by Lurich on 2024/6/2.
//

import SwiftUI

struct ContentView2: View {
    @State private var timer: CGFloat = 0
    @State private var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                HStack {
                    FlipClockTextEffect(
                        value: .constant(count / 10),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 100,
                        cornerRadius: 10,
                        foreground: .black,
                        background: .white
                    )
                    
                    FlipClockTextEffect(
                        value: .constant(count % 10),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 100,
                        cornerRadius: 10,
                        foreground: .black,
                        background: .white
                    )
                }
                .onReceive(Timer.publish(every: 0.01, on: .current, in: .common).autoconnect(), perform: { _ in
                    timer += 0.01
                    if timer >= 60 {
                        timer = 0
                    }
                    count = Int(timer)
                })
                
                Text("This is a 60s Loop Timer")
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Flip Clock Effect")
        }
    }
}

#Preview {
    ContentView2()
}
