//
//  ContentView.swift
//  TextRendererEffect
//
//  Created by Lurich on 2024/6/14.
//

import SwiftUI

struct ContentView: View {
    @State private var reveal: Bool = false
    @State private var type: RevealRenderer.RevealType = .blur
    @State private var revealProgress: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("reveal type picker", selection: $type) {
                    ForEach(RevealRenderer.RevealType.allCases, id: \.self) { item in
                        Text(item.rawValue)
                            .tag(item)
                    }
                }
                .pickerStyle(.segmented)

                
                let apiKey = Text("xLuRfIoCaHi")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .customAttribute(ApiKeyAttribute())
                
                Text("Your API Key is \(apiKey) \n Don't share this with anyone!")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundStyle(.gray)
                    .textRenderer(RevealRenderer(type: type, progress: revealProgress))
                    .padding(.vertical, 20)
                
                Button {
                    reveal.toggle()
                    withAnimation(.smooth) {
                        revealProgress = reveal ? 1 : 0
                    }
                } label: {
                    Text(reveal ? "Hide Key" : "Reveal Key")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .frame(width: 130)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.black)
                
                Spacer(minLength: 0)
            }
            .animation(.snappy, value: reveal)
            .padding(15)
            .navigationTitle("Text Renderer")
        }
    }
}

#Preview {
    ContentView()
}

struct ApiKeyAttribute: TextAttribute {
    /// 自定义用来标识
}

struct RevealRenderer: TextRenderer, Animatable {
    var type: RevealType = .blur
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let lines = layout.flatMap({ $0 })
        for line in lines {
            if let _ = line[ApiKeyAttribute.self] {
                var localContext = ctx
                let blurProgress: CGFloat = 5 - 5 * progress
                let blurFilter = GraphicsContext.Filter.blur(radius: blurProgress)
                
                let pixellateProgress: CGFloat = 5 - 4 * progress
                let pixellateFilter = GraphicsContext.Filter.distortionShader(ShaderLibrary.pixellate(.float(pixellateProgress)), maxSampleOffset: .zero)
                
                localContext.addFilter(type == .blur ? blurFilter : pixellateFilter)
                localContext.draw(line)
            } else {
                ctx.draw(line)
            }
        }
    }
    
    enum RevealType: String, CaseIterable {
        case blur = "Blur"
        case pixellate = "Pixellate"
    }
}
