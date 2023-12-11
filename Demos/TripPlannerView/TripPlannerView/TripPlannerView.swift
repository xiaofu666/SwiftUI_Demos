//
//  TripPlannerView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/7/6.
//

import SwiftUI

private enum TripPicker: String, CaseIterable {
    case normal = "Normal"
    case scaled = "Scaled"
}

struct TripPlannerView: View {
    @State private var pickerType: TripPicker = .normal
    @State private var activeID: Int?
    
    var body: some View {
        VStack {
            Picker("", selection: $pickerType) {
                ForEach(TripPicker.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer()
            
            GeometryReader(content: { geometry in
                let size = geometry.size
                let padding = (size.width - 70) / 2.0
                
                ScrollView(.horizontal) {
                    HStack(spacing: 35, content: {
                        ForEach(1...6, id: \.self) { index in
                            Image("user\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
                                .visualEffect { view, proxy in
                                    view
                                        .offset(y: offset(proxy))
                                        .offset(y: scale(proxy) * 15)
                                }
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
//                                        .offset(y: phase == .identity && activeID == index ? 15 : 0)
                                        .scaleEffect(phase == .identity && pickerType == .scaled ? 1.5 : 1, anchor: .bottom)
                                }
                        }
                    })
                    .offset(y: -30)
                    .frame(height: size.height)
                    .scrollTargetLayout()
                }
                .background(content: {
                    if pickerType == .normal {
                        Circle()
                            .fill(.white.shadow(.drop(color: .black.opacity(0.2), radius: 5)))
                            .frame(width: 85, height: 85)
                            .offset(y: -15)
                            
                    }
                })
                .safeAreaPadding(.horizontal, padding)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID)
                .frame(height: size.height)
            })
            .frame(height: 200)
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let progress = progress(proxy)
        return progress < 0 ? progress * -30 : progress * 30
    }
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let progress = min(max(progress(proxy), -1), 1)
        return progress < 0 ? 1 + progress : 1 - progress
    }
    func progress(_ proxy: GeometryProxy) -> CGFloat {
        let width = proxy.size.width
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        return minX / width
    }
}

#Preview {
    TripPlannerView()
}
