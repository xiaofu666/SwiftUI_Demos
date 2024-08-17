//
//  Home.swift
//  Custom_Header
//
//  Created by Xiaofu666 on 2024/8/17.
//

import SwiftUI

struct Home: View {
    @State private var searchText: String = ""
    @State private var progress: CGFloat = 0
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(sampleItems) { item in
                    CardView(item)
                }
            }
            .padding(15)
            .offset(y: isFocused ? 0 : 75 * progress)
            .padding(.bottom, 75)
            .safeAreaInset(edge: .top, spacing: 0) {
                ResizableHeader()
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(CustomScrollTarget())
        .animation(.snappy(duration: 0.3), value: isFocused)
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            proxy.contentOffset.y + proxy.contentInsets.top
        } action: { oldValue, newValue in
            progress = max(min(newValue / 75, 1.0), 0.0)
        }

    }
    
    @ViewBuilder
    func ResizableHeader() -> some View {
        let progress = isFocused ? 1 : progress
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome Back!")
                        .font(.callout)
                        .foregroundStyle(.gray)
                    
                    Text("xiaofu666")
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(.circle)
                }
            }
            .frame(height: 60 - 60 * progress, alignment: .bottom)
            .padding([.horizontal, .top], 15)
            .padding(.bottom, 15 - 15 * progress)
            .opacity(1 - progress)
            .offset(y: -10 * progress)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                
                TextField("Search Photos", text: $searchText)
                    .focused($isFocused)
                
                Button {
                    
                } label: {
                    Image(systemName: "microphone.fill")
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.background).shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5).shadow(color: .black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding(.top, isFocused ? -100 : 0)
            }
            .padding(.horizontal, isFocused ? 0 : 15)
            .padding(.bottom, 10)
            .padding(.top, 5)
        }
        .background() {
            ProgressiveBlurView()
                .blur(radius: isFocused ? 0 : 10)
                .padding(.horizontal, -15)
                .padding(.bottom, -10)
                .padding(.top, -100)
        }
        .visualEffect { content, proxy in
            content
                .offset(y: offsetY(proxy))
        }
    }
    
    nonisolated private
    func offsetY(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        return minY > 0 ? (isFocused ? -minY : 0) : -minY
    }
    
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { proxy in
                let size = proxy.size
                
                if let image = item.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(.rect(cornerRadius: 20))
                }
            }
            .frame(height: 250)
            
            Text("\(item.title)")
                .font(.callout)
                .foregroundStyle(.primary.secondary)
        }
    }
}

struct CustomScrollTarget: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let endPoint = target.rect.minY
        if endPoint < 75 {
            if endPoint > 40 {
                target.rect.origin = .init(x: 0, y: 75)
            } else {
                target.rect.origin = .zero
            }
        }
    }
}

#Preview {
    ContentView()
}
