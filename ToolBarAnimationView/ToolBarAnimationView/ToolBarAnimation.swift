//
//  Home.swift
//  ToolBarAnimation0809
//
//  Created by Lurich on 2022/8/9.
//

import SwiftUI

struct Tool: Identifiable {
    var id: String = UUID().uuidString
    var icon: String
    var name: String
    var color: Color
    var toolPosition: CGRect = .zero
}

@available(iOS 16.0, *)
struct ToolBarAnimation: View {
    
    @State var tools: [Tool] = [
        .init(icon: "scribble.variable", name: "Scribble", color: .purple),
        .init(icon: "lasso", name: "Lasso", color: .green),
        .init(icon: "plus.bubble", name: "Comment", color: .blue),
        .init(icon: "bubbles.and.sparkles.fill", name: "Enhance", color: .orange),
        .init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
        .init(icon: "rotate.3d", name: "Rotate", color: .indigo),
        .init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow)
    ]
    @State var activeTool: Tool?
    @State var startedToolPostion: CGRect = .zero
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach($tools) { $tool in
                    ToolView(tool: $tool)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(
                        .drop(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    ).shadow(
                        .drop(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                    ))
                    .frame(width: 65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .coordinateSpace(name: "AREA")
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        
                        guard let firstTool = tools.first else{return}
                        if startedToolPostion == .zero {
                            startedToolPostion = firstTool.toolPosition
                        }
                        let location = CGPoint(x: startedToolPostion.midX, y: value.location.y)
                        
                        if let index = tools.firstIndex(where: { tool in
                            tool.toolPosition.contains(location)
                        }), activeTool?.id != tools[index].id {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                                activeTool = tools[index]
                            }
                        }
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                            activeTool = nil
                            startedToolPostion = .zero
                        }
                    })
            )
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func ToolView(tool: Binding<Tool>) -> some View {
        HStack(spacing: 5) {
            Image(systemName: tool.wrappedValue.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .padding(.leading, activeTool?.id == tool.id ? 5 : 0)
                .background {
                    
                    GeometryReader{proxy in
                        let frame = proxy.frame(in: .named("AREA"))
                        Color.clear
                            .preference(key: RectKey.self, value: frame)
                            .onPreferenceChange(RectKey.self) { rect in
                                tool.wrappedValue.toolPosition = rect
                            }
                        
                    }
                }
            if activeTool?.id == tool.id {
                
                Text(tool.wrappedValue.name)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
            }
        }
        .background {
            
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tool.wrappedValue.color.gradient)
        }
        .offset(x: activeTool?.id == tool.wrappedValue.id ? 60 : 0)
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

@available(iOS 16.0, *)
struct ToolBarAnimation_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarAnimation()
    }
}
