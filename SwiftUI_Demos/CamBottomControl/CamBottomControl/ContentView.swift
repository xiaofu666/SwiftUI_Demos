//
//  ContentView.swift
//  CamBottomControl
//
//  Created by Xiaofu666 on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    @State private var tabs: [SegmentedTab] = [
        .init(id: 0, title: "TIME LAPSE"),
        .init(id: 1, title: "SLO-MO"),
        .init(id: 2, title: "PHOTO"),
        .init(id: 3, title: "VIDEO"),
        .init(id: 4, title: "PORTRAIT"),
        .init(id: 5, title: "PANO")
    ]
    @State private var isSegmentedGestureActive: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
            .fill(.black)
            .backgroundExtensionEffect()
            
            Rectangle()
            .fill(.gray.opacity(0.1))
            .frame(height: 200)
            .overlay {
                VStack(spacing: 15) {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                    
                    Spacer(minLength:0)
                    // Custom Bottom With Custom Segmented Control
                    HStack(spacing: 20) {
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                        }
                        .offset(x: isSegmentedGestureActive ? -100 : 0)
                        
                        CustomSegmentedControl(initialIndex: 2, horizontalPadding: 60, tabs: $tabs) { index in
                            
                        } gestureStatus: { isActive in
                            isSegmentedGestureActive = isActive
                        }
                        
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(.gray.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                                        .foregroundStyle(.white)
                                }
                        }
                        .offset(x: isSegmentedGestureActive ? 100 : 0)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}
