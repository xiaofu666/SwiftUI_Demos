//
//  TransparentBlurView.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/26.
//

import SwiftUI

struct TransparentBlurView: View {
    @State private var activePic: String = "Pic"
    @State private var blurType: BlurType = .freeStyle
    
    var body: some View {
        GeometryReader(content: { geometry1 in
            ScrollView(.vertical) {
                VStack(spacing: 15, content: {
                    TransparentBlurUIView(removeAllFilters: true)
                        .blur(radius: 15, opaque: blurType == .clipped)
                        .padding([.horizontal, .vertical], -30)
                        .frame(height: 140 + geometry1.safeAreaInsets.top)
                        .visualEffect { view, proxy in
                            view
                                .offset(y: proxy.bounds(of: .scrollView)?.minY ?? 0)
                        }
                        .zIndex(1000)
                    
                    VStack(alignment:.leading, spacing: 10, content: {
                        GeometryReader(content: { geometry2 in
                            Image(activePic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry2.size.width, height: geometry2.size.height)
                                .clipShape(.rect(cornerRadius: 25))
                        })
                        .frame(height: 500)
                        
                        Text("Blur Style")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.top, 15)
                        
                        Picker("", selection: $blurType) {
                            ForEach(BlurType.allCases, id: \.self) { type in
                                Text("\(type.rawValue)")
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    })
                    .padding(15)
                    .padding(.bottom, 500)
                })
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea(.container, edges: .top)
        })
    }
}

#Preview {
    TransparentBlurView()
}

enum BlurType: String, CaseIterable {
    case clipped = "Clipped"
    case freeStyle = "Free Style"
}
