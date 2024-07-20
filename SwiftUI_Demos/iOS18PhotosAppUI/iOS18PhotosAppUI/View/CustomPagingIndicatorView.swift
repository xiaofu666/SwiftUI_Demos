//
//  CustomPagingIndicatorView.swift
//  iOS18PhotosAppUI
//
//  Created by Xiaofu666 on 2024/7/21.
//

import SwiftUI

struct CustomPagingIndicatorView: View {
    var onClose: () -> ()
    @Environment(ShareData.self) private var shareData
    @Namespace private var animation
    
    var body: some View {
        let progress = shareData.progress
        
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .opacity(index == 3 ? 0 : 1)
                    .overlay {
                        if index == 3 {
                            Image(systemName: "square.grid.2x2.fill")
                                .font(.system(size: 10))
                        }
                    }
                    .scaleEffect(shareData.activePage == index ? 1.2 : 1)
                    .frame(width: 7, height: 7)
                    .foregroundStyle(shareData.activePage == index ? .primary : .secondary)
            }
        }
        .blur(radius: progress * 5)
        .opacity(1.0 - progress * 5)
        .overlay(alignment: .center) {
            CustomBottomBars()
                .fixedSize()
                .blur(radius: 1 - progress * 5)
                .opacity(progress)
        }
        .offset(y: -20 - progress * 30)
    }
    
    @ViewBuilder
    func CustomBottomBars() -> some View {
        HStack(spacing: 10) {
            Button {
                
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .frame(width: 35, height: 35)
                    .background(.ultraThinMaterial, in: .circle)
            }
            
            HStack(spacing: 0) {
                ForEach(["年", "月", "全部"], id: \.self) { category in
                    Button {
                        withAnimation(.snappy) {
                            shareData.selectedCategory = category
                        }
                    } label: {
                        Text(category)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 6)
                            .background() {
                                if shareData.selectedCategory == category {
                                    Capsule()
                                        .fill(.gray.opacity(0.15))
                                        .matchedTransitionSource(id: "ACTIVE_TAB", in: animation)
                                }
                            }
                    }
                }
            }
            .background(.ultraThinMaterial, in: .capsule)
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .frame(width: 35, height: 35)
                    .background(.ultraThinMaterial, in: .circle)
                    .contentShape(.circle)
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    ContentView()
}
