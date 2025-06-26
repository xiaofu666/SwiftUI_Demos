//
//  ContentView.swift
//  AppleMusicBottomBar
//
//  Created by Xiaofu666 on 2025/6/26.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var expandMiniPlayer: Bool = false
    @Namespace private var animation
    
    var body: some View {
        NativeTabView()
            .tabBarMinimizeBehavior(.onScrollDown)
            .tabViewBottomAccessory {
                MiniPlayerView()
                    .matchedGeometryEffect(id: "MINIPLAYER", in: animation)
                    .onTapGesture {
                        expandMiniPlayer.toggle()
                    }
            }
            .fullScreenCover(isPresented: $expandMiniPlayer){
                ScrollView {
                }
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack(spacing: 10) {
                        // Drag Indicator Mimick
                        Capsule()
                            .foregroundStyle(.primary.secondary)
                            .frame(width: 35, height: 3)
                        
                        HStack(spacing: 0) {
                            PlayerInfo(.init(width: 80,height: 80))
                            
                            Spacer(minLength:0)
                            
                            /// Expanded Actions
                            Group {
                                Button("", systemImage: "star.circle.fill") {
                                }
                                Button("", systemImage: "ellipsis.circle.fill") {
                                }
                            }
                            .font(.title)
                            .foregroundStyle(Color.primary, Color.primary.opacity(0.1))
                        }
                        .padding(.horizontal, 15)
                    }
                    .navigationTransition(.zoom(sourceID: "MINIPLAYER", in: animation))
                }
                /// To Avoid Transparency!
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background)
                
            }
    }
    
    // Let's First start with TabView
    @ViewBuilder
    func NativeTabView() -> some View {
        TabView {
            Tab.init("Home", systemImage: "house.fill") {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("Home")
                }
            }
            Tab.init("New", systemImage: "square.grid.2x2.fill") {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("What's New")
                }
            }
            Tab.init("Radio", systemImage: "dot.radiowaves.left.and.right") {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("Radio")
                }
            }
            Tab.init("Library", systemImage: "square.stack.fill") {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("Library")
                }
            }
            Tab.init("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("Search")
                    .searchable(text: $searchText, placement: .toolbar, prompt: Text("Search..."))
                }
            }
        }
    }
    
    // Resuable player Info
    @ViewBuilder
    func PlayerInfo(_ size: CGSize) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: size.height / 4)
                .fill(.blue.gradient)
                .frame(width: size.width, height: size.height)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Some Apple Music Title")
                    .font(.callout)
                
                Text("Some Artist Name")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
        }
    }
    
    // MiniPlayer View
    @ViewBuilder
    func MiniPlayerView() -> some View {
        HStack(spacing: 15) {
            PlayerInfo(.init(width: 30, height: 30))
            
            Spacer(minLength:0)
            
            /// Action Buttons
            Button {
            } label: {
                Image(systemName:"play.fill")
                    .contentShape(.rect)
            }
            .padding(.trailing, 10)
            
            Button {
            } label: {Image(systemName: "forward.fill")
                    .contentShape(.rect)
            }
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    ContentView()
}
