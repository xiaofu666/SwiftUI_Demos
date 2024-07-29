//
//  IntroView.swift
//  Walkthrough+Morphing
//
//  Created by Xiaofu666 on 2024/7/29.
//

import SwiftUI

struct IntroView: View {
    @State private var activePage: Page = .page1
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                VStack {
                    MorphingSymbolView(
                        symbol: activePage.rawValue,
                        config: .init(
                            font: .system(size: 150, weight: .bold),
                            frame: .init(width: 250, height: 200),
                            radius: 30,
                            foregroundColor: .primary
                        )
                    )
                    
                    TextContents(size: size)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                VStack(spacing: 30) {
                    IndicatorView()
                    
                    ContinueButton()
                }
            }
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .background {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func TextContents(size: CGSize) -> some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.title)
                        .font(.title2)
                        .lineLimit(1)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .kerning(1.1)
                        .frame(width: size.width)
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.7, extraBounce: 0.1), value: activePage)
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(Page.allCases, id: \.rawValue) { page in
                    Text(page.subTitle)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                        .frame(width: size.width)
                }
            }
            .offset(x: -activePage.index * size.width)
            .animation(.smooth(duration: 0.9, extraBounce: 0.1), value: activePage)
        }
        .padding(.top, 15)
        .frame(width: size.width, alignment: .leading)
    }
    
    @ViewBuilder
    func IndicatorView() -> some View {
        HStack(spacing: 8) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                Capsule()
                    .fill(activePage == page ? Color.primary : .secondary)
                    .frame(width: activePage == page ? 25 : 8, height: 8)
            }
        }
        .animation(.smooth(duration: 0.5), value: activePage)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                activePage = activePage.previousPage
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .contentShape(.rect)
            }
            .opacity(activePage != .page1 ? 1 : 0)
            
            Spacer(minLength: 0)
            
            Button("Skip") {
                activePage = .page4
            }
            .fontWeight(.semibold)
            .opacity(activePage == .page4 ? 0 : 1)
        }
        .foregroundStyle(.primary)
        .padding(15)
        .animation(.snappy(duration: 0.35), value: activePage)
    }
    
    @ViewBuilder
    func ContinueButton() -> some View {
        Button {
            activePage = activePage.nextPage
        } label: {
            Text(activePage == .page4 ? "Login into SwiftUI App" : "Continue")
                .contentTransition(.identity)
                .foregroundStyle(.background)
                .frame(width: activePage == .page4 ? 220 : 180)
                .padding(.vertical, 15)
                .background(.primary, in: .capsule)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 15)
        .animation(.smooth(duration: 0.5), value: activePage)
    }
}

#Preview {
    IntroView()
        .preferredColorScheme(.dark)
}
