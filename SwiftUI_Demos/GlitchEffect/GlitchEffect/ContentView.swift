//
//  ContentView.swift
//  GlitchEffect
//
//  Created by Lurich on 2024/6/7.
//

import SwiftUI

struct ContentView: View {
    @State private var trigger: (Bool, Bool, Bool) = (false, false, false)
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                GlitchTextView("Hello Xiaofu", trigger: trigger.0)
                    .font(.system(size: 60, weight: .semibold))
                
                GlitchTextView("Glitch Text Effect", trigger: trigger.1)
                    .font(.system(size: 40, design: .rounded))
                
                GlitchTextView("By @Lurich", trigger: trigger.2)
                    .font(.system(size: 20))
            }
            
            Button {
                Task {
                    trigger.0.toggle()
                    try? await Task.sleep(for: .seconds(0.6))
                    trigger.1.toggle()
                    try? await Task.sleep(for: .seconds(0.6))
                    trigger.2.toggle()
                }
            } label: {
                Text("Trigger")
                    .padding(5)
            }
            .padding(.top, 20)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    @ViewBuilder
    func GlitchTextView(_ text: String, trigger: Bool) -> some View {
        ZStack {
            GlitchText(
                text: text,
                trigger: trigger,
                shadow: .red,
                radius: 1
            ) {
                LinearKeyframe(
                    GlitchFrame(top: -5, center: 0, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: -5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: -5, center: -5, bottom: 5, shadowOpacity: 0.8),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.4),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 0, bottom: 5, shadowOpacity: 0.1),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
            }
            
            GlitchText(
                text: text,
                trigger: trigger,
                shadow: .green,
                radius: 1
            ) {
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: 0, shadowOpacity: 0.2),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: 5, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 5, center: 5, bottom: -5, shadowOpacity: 0.5),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: 5, bottom: -5, shadowOpacity: 0.6),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(top: 0, center: -5, bottom: 0, shadowOpacity: 0.3),
                    duration: 0.1
                )
                LinearKeyframe(
                    GlitchFrame(),
                    duration: 0.1
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
