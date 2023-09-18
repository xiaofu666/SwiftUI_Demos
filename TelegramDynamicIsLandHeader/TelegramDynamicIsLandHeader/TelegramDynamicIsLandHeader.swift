//
//  TelegramDynamicIsLandHeader.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/6/10.
//

import SwiftUI

@available(iOS 16.0, *)
struct TelegramDynamicIsLandHeaderView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    let coordinateName = "TelegramDynamicIsLandHeaderView"
    @State private var scrollProgress: CGFloat = 0
    @State private var textHeaderOffsetY: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let isHaveNotch = safeArea.bottom != 0
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 12) {
                Image("Pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (130 - (75 * scrollProgress)), height: (130 - (75 * scrollProgress)))
                    .opacity(1 - scrollProgress)
                    .blur(radius: scrollProgress * 10, opaque: true)
                    .clipShape(Circle())
                    .anchorPreference(key: CardRectKey.self, value: .bounds, transform: { anchor in
                        return ["HEADER":anchor]
                    })
                    .padding(.top, safeArea.top + 15)
                    .getRectFor(key: coordinateName) { rect in
                        guard isHaveNotch else { return }
                        let progress = -rect.minY / 25
                        scrollProgress = min(max(progress, 0), 1)
                    }
                
                Text("小富")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 15)
                    .background(content: {
                        Rectangle()
                            .fill(colorScheme == .dark ? .black : .white)
                            .frame(width: size.width)
                            .padding(.top, textHeaderOffsetY < safeArea.top ? -safeArea.top : 0)
                            .shadow(color: .black.opacity(textHeaderOffsetY < safeArea.top ? 0.1 : 0), radius: 5, x: 0, y: 5)
                    })
                    .offset(y: textHeaderOffsetY < safeArea.top ? -(textHeaderOffsetY - safeArea.top) : 0)
                    .getRectFor(key: coordinateName) { rect in
                        textHeaderOffsetY = rect.minY
                    }
                    .zIndex(100)
                
                SampleRows()
            }
            .frame(maxWidth: .infinity)
        }
        .backgroundPreferenceValue(CardRectKey.self, { pref in
            GeometryReader { proxy in
                if let anchor = pref["HEADER"], isHaveNotch {
                    let frameRect = proxy[anchor]
                    let isHaveDynamic = safeArea.top > 51
                    let capHeight = isHaveDynamic ? 37 : (safeArea.top - 15)
                    
                    Canvas { out, size in
                        out.addFilter(.alphaThreshold(min: 0.5))
                        out.addFilter(.blur(radius: 12))
                        
                        out.drawLayer { ctx in
                            if let headerView = out.resolveSymbol(id: 0) {
                                ctx.draw(headerView, in: frameRect)
                            }
                            
                            if let dynamicView = out.resolveSymbol(id: 1) {
                                let rect = CGRect(x: (size.width - 120) / 2, y: isHaveDynamic ? 11 : 0, width: 120, height: capHeight)
                                ctx.draw(dynamicView, in: rect)
                            }
                        }
                    } symbols: {
                        HeaderView(frameRect)
                            .tag(0)
                            .id(0)
                        
                        DynamicIsLandCapsule(capHeight)
                            .tag(1)
                            .id(1)
                    }

                }
            }
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(colorScheme == .dark ? .black : .white)
                    .frame(height: 15)
            }
        })
        .coordinateSpace(name: coordinateName)
    }
    
    @ViewBuilder
    func HeaderView(_ frameRect: CGRect) -> some View {
        Circle()
            .fill(.black)
            .frame(width: frameRect.width, height: frameRect.height)
    }
    
    @ViewBuilder
    func DynamicIsLandCapsule(_ height: CGFloat = 37) -> some View {
        Rectangle()
            .fill(.black)
            .frame(width: 120, height: height)
     }
    
    @ViewBuilder
    func SampleRows() -> some View {
        VStack {
            ForEach(1...20, id: \.self) { _ in
                VStack(spacing: 5) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 25)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 20)
                        .padding(.trailing, 50)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 15)
                        .padding(.trailing, 150)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom + 15)
    }
}

@available(iOS 16.0, *)
struct TelegramDynamicIsLandHeader_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
