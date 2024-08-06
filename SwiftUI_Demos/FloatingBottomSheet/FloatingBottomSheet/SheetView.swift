//
//  SheetView.swift
//  FloatingBottomSheet
//
//  Created by Xiaofu666 on 2024/8/6.
//

import SwiftUI

struct SheetView: View {
    var title: String
    var content: String
    var image: Config
    var button1: Config
    var button2: Config?
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
            
            Text(title)
                .font(.title3.bold())
            
            Text(content)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.gray)
            
            ButtonView(button1)
            
            if let button2 {
                ButtonView(button2)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    func ButtonView(_ config: Config) -> some View {
        Button {
            
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
    
    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
    }
}

#Preview {
    ContentView()
}
