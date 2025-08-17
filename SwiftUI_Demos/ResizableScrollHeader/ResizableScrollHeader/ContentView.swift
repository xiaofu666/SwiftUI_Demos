//
//  ContentView.swift
//  ResizableScrollHeader
//
//  Created by Xiaofu666 on 2025/8/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Example 1") {
                    Example1View()
                }
                NavigationLink("Example 2") {
                    Example2View()
                        .navigationBarBackButtonHidden()
                }
            }
            .navigationTitle("Resizable Header")
        }
    }
}

struct Example1View: View {
    @State private var isSticky: Bool = false
    
    var body: some View {
        ResizableHeaderScrollView(minimumHeight: 100, maximumHeight: 250, ignoresSafeAreaTop: false, isSticky: isSticky) { progress, safeArea in
            GeometryReader {
                let height = $0.size.height
                
                RoundedRectangle(cornerRadius: 30)
                    .fill(.indigo.gradient)
                    .overlay {
                        Text("\(height)")
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
            }
        } content: {
            VStack(spacing: 12) {
                Toggle("Sticky Header", isOn: $isSticky)
                    .padding(15)
                    .background(.gray.opacity(0.2), in: .rect(cornerRadius: 15))

                DummyContentView()
            }
            .padding(15)
        }
    }
}

struct Example2View: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ResizableHeaderScrollView(minimumHeight: 70, maximumHeight: 200, ignoresSafeAreaTop: true, isSticky: false) { progress, safeArea in
            HeaderView(progress)
        } content: {
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Button {
                    } label:{
                        VStack(spacing: 6) {
                            Text("Install to +")
                                .foregroundStyle(.white)
                            
                            Text("Xbox Series Xls")
                                .font(.caption)
                                .foregroundStyle(.white.secondary)
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height:60)
                        .background(Color(UIColor.systemGreen),in: .rect(cornerRadius: 10))
                    }
                    
                    HStack(spacing: 10) {
                        Button {
                        } label:{
                            VStack(spacing: 6) {
                                Text("Buy")
                                    .foregroundStyle(.white)
                                
                                Text("Some Amount...")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height:60)
                            .background(.gray.opacity(0.2),in: .rect(cornerRadius: 10))
                        }
                        
                        Button {
                        } label:{
                            Image(systemName:"ellipsis")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .frame(width: 80, height: 60)
                                .background(.gray.opacity(0.2), in: .rect(cornerRadius: 10))
                        }
                    }
                }

                DummyContentView()
            }
            .padding(15)
        }
        .preferredColorScheme(.dark)
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView(_ progress: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            /// Back Button
            Button {
                dismiss()
            } label: {
                Image(systemName:"chevron.left")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .frame(width: 35, height: 35)
                    .background(.bar, in: .rect(cornerRadius: 10))
            }
            .offset(y: 58 * progress)
            
            /// Image and Title
            HStack(spacing: 12) {
                let size: CGFloat = 120 - progress * 80
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(.rect(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("RESIDENT EVIL 2")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("CAPCOM CO., LTD.")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .compositingGroup()
                .scaleEffect(1 - progress * 0.2, anchor: .leading)
            }
            .offset(x: 45 * progress)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .background {
            let opacity = (progress - 0.7) / 0.3
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(opacity)
        }
    }
}

struct DummyContentView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating:GridItem(), count:2)) {
            ForEach(1...50, id: \.self) { index in
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .frame(height:160)
            }
        }
    }
}

#Preview {
    ContentView()
}
