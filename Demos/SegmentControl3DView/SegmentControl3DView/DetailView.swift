//
//  DetailView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/2.
//

import SwiftUI

struct DetailView: View {
    @State private var currentTab: TopTab = .photo
    @State private var shakeValue: CGFloat = 0
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack {
            SegmentedControl()
                .padding(5)
            
            TabView(selection: $currentTab) {
                SampleGridView()
                    .tag(TopTab.photo)
                SampleGridView(true)
                    .tag(TopTab.video)
            }
        }
    }
    
    @ViewBuilder
    func SegmentedControl() -> some View {
        HStack(spacing: 0) {
            TopTabText(.photo)
                .foregroundColor(Color("Pink"))
                .overlay {
                    ClipCornerShape(corners: [.topLeft, .bottomLeft], radius: 50)
                        .fill(Color("Pink"))
                        .overlay {
                            TopTabText(.video)
                                .foregroundColor(currentTab == .video ? .white : .clear)
                                .scaleEffect(x: -1)
                        }
                        .overlay {
                            TopTabText(.photo)
                                .foregroundColor(currentTab == .video ? .clear : .white)
                        }
                        .rotation3DEffect(.init(degrees: currentTab == .photo ? 0 : 180), axis: (x: 0, y: 1, z: 0), anchor: .trailing, perspective: 0.45)
                    
                }
                .zIndex(1)
                .contentShape(Rectangle())
            TopTabText(.video)
                .foregroundColor(Color("Pink"))
                .zIndex(0)
        }
        .background {
            ZStack {
                Capsule()
                    .fill(.white)
                
                Capsule()
                    .stroke(Color("Pink"), lineWidth: 3)
            }
        }
        .rotation3DEffect(.init(degrees: shakeValue), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func TopTabText(_ tab: TopTab) -> some View {
        Text(tab.rawValue)
            .font(.title3)
            .fontWeight(.semibold)
            .contentTransition(.interpolate)
            .padding(.horizontal, 40)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    currentTab = tab
                }
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                    shakeValue = (currentTab == .video) ? 10 : -10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                        shakeValue = 0
                    }
                }
            }
    }
    
    @ViewBuilder
    func SampleGridView(_ displayGridView: Bool = false) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 5), count: 3)) {
                ForEach(1...30, id: \.self) { index in
                    Rectangle()
                        .fill(Color("Pink").opacity(0.2))
                        .frame(height: 130)
                        .overlay(alignment: .topTrailing) {
                            if displayGridView {
                                Circle()
                                    .fill(Color("Pink").opacity(0.3))
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                            }
                        }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
