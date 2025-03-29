//
//  ContentView.swift
//  StaggeredAnimation
//
//  Created by Xiaofu666 on 2025/3/29.
//

import SwiftUI

struct ContentView: View {
    @State private var showView: Bool = false
    @State private var isSameDirection: Bool = false
    @State private var isHorizontally: Bool = false
    @State private var scale: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Toggle("Same Direction", isOn: $isSameDirection)
                    
                    Toggle("Horizontally", isOn: $isHorizontally)
                }
                HStack {
                    Text("Scale")
                    
                    Slider(value: $scale, in: 0.2...1)
                }
                
                Button {
                    showView.toggle()
                } label: {
                    Text("Toggle View")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                let config = StaggeredConfig(
                    offset: isHorizontally ? .init(width: 400, height: 0) : .init(width: 0, height: 100),
                    scale: scale,
                    disappearInSameDirection: isSameDirection
                )
                StaggeredView(config: config) {
                    if showView {
                        ForEach(1...10, id: \.self) { _ in
                            DummyView()
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .navigationTitle("Staggered Animation")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    /// Dummy View
    @ViewBuilder
    func DummyView() -> some View {
        HStack(spacing: 10) {
            Circle()
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 10)
                    .padding(.trailing, 20)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 10)
                    .padding(.trailing, 140)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 10)
            }
        }
        .foregroundStyle(.gray.opacity(0.7).gradient)
    }
}

#Preview {
    ContentView()
}
