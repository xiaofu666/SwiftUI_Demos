//
//  ContentView.swift
//  VisionOSMenuBar
//
//  Created by Xiaofu666 on 2025/3/16.
//

import SwiftUI

extension ColorScheme {
    var currentColor: Color {
        switch self {
        case .light:
            return .white
        case .dark:
            return .black
        default:
            return .clear
        }
    }
}

struct ContentView: View {
    @State private var isExpanded: Bool = false
    @State private var menuPosition: CGRect = .zero
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView()
            
            ScrollView(.vertical) {
                DummyTestView()
            }
        }
        .overlay(alignment: .topLeading) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy(duration: 0.3)) {
                            isExpanded = false
                        }
                    }
                    .allowsHitTesting(isExpanded)
                
                ZStack {
                    if isExpanded {
                        VisionOSStyleView {
                            MenuBarControls()
                                .frame(width: 220, height: 270)
                        }
                    }
                }
                .offset(x: menuPosition.maxX - 220, y: menuPosition.maxY + 10)
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Text("Notes")
                .font(.largeTitle.bold())
            
            Spacer(minLength: 0)
            
            Button {
                withAnimation(.smooth) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundStyle(isExpanded ? colorScheme.currentColor : Color.primary)
                    .frame(width: 45, height: 45)
                    .background {
                        ZStack {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                            
                            Rectangle()
                                .fill(Color.primary.opacity(isExpanded ? 1 : 0.003))
                        }
                        .clipShape(.circle)
                    }
            }
            .onGeometryChange(for: CGRect.self) { proxy in
                proxy.frame(in: .global)
            } action: { newValue in
                menuPosition = newValue
            }
        }
        .padding(15)
    }
    
    @ViewBuilder
    func DummyTestView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(.testImg)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Neuschwanstein Castle")
                    .font(.title.bold())
            }
            .padding(15)
        }
    }
}

struct MenuBarControls: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                ForEach(["document.viewfinder", "pin.fill", "lock.fill"], id: \.self) { image in
                    Button {
                    } label: {
                        Image(systemName: image)
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
            }
            
            /// Custom Divider
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 1)
            
            CustomButton(title:"Find in Note", image:"magnifyingglass")
            
            CustomButton(title:"Move Note",image: "folder")
            
            CustomButton(title: "Lines & Grids",image: "squareshape.split.3x3")
            
            CustomButton(title:"Delete",image:"trash" )
        }
        .padding(20)
    }
    
    @ViewBuilder
    private func CustomButton(title: String, image: String, action: @escaping() -> () = { }) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 13))
                
                Spacer(minLength: 0)
                
                Image(systemName: image)
                    .frame(width: 20)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
