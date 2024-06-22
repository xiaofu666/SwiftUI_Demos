//
//  YoutubeHomeView2.swift
//  YoutubeHomeView
//
//  Created by Lurich on 2024/6/21.
//

import SwiftUI

@available(iOS 18.0, *)
struct YoutubeHomeView2: View {
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let headerHeight = 60 + safeArea.top
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(1...10, id: \.self) { index in
                        DummyView(for: index)
                    }
                }
                .padding(15)
            }
            .safeAreaInset(edge: .top) {
                HeaderView()
                    .frame(height: headerHeight, alignment: .bottom)
                    .background(.background)
                    .offset(y: -headerOffset)
            }
            .onScrollGeometryChange(for: CGFloat.self) { proxy in
                let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                return max(min(proxy.contentOffset.y + headerHeight, maxHeight), 0)
            } action: { oldValue, newValue in
                self.isScrollingUp = oldValue < newValue
                headerOffset = min(max(newValue - lastNaturalOffset, 0), headerHeight)
                
                naturalScrollOffset = newValue
            }
            .onScrollPhaseChange { oldPhase, newPhase, context in
                if !newPhase.isScrolling && (headerOffset != 0 && headerOffset != headerHeight) {
                    withAnimation(.snappy(duration: 0.25)) {
                        if headerOffset > headerHeight * 0.5 && naturalScrollOffset > headerHeight {
                            headerOffset = headerHeight
                        } else {
                            headerOffset = 0
                        }
                        lastNaturalOffset = naturalScrollOffset - headerOffset
                    }
                }
            }
            .onChange(of: isScrollingUp) { oldValue, newValue in
                lastNaturalOffset = naturalScrollOffset - headerOffset
            }
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    @ViewBuilder
    func DummyView(for index: Int) -> some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 220)
                .overlay {
                    Image("user\(index%6 + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .clipShape(.rect(cornerRadius: 8))
            
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 50)
                
                VStack {
                    RoundedRectangle(cornerRadius: 6)
                    
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 6)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.tertiary)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack (spacing: 20){
            Image(systemName: "play.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 10, height: 10)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.red)
                .cornerRadius(5)
            
            Text("Youtube")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .kerning(0.5)
                .offset(x: -10)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "display")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.background)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        YoutubeHomeView2()
    } else {
        // Fallback on earlier versions
    }
}
