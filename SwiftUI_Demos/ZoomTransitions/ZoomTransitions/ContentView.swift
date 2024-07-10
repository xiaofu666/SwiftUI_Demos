//
//  ContentView.swift
//  ZoomTransitions
//
//  Created by Lurich on 2024/7/10.
//

import SwiftUI

struct ContentView: View {
    var sharedModel = SharedModel()
    @Namespace private var animation
    var body: some View {
        @Bindable var binding = sharedModel
        GeometryReader {
            let screenSize = $0.size
            
            NavigationStack {
                VStack(spacing: 0) {
                    HeaderView()
                    
                    ScrollView(.vertical) {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                            ForEach($binding.videos) { $video in
                                NavigationLink(value: video) {
                                    CardView(screenSize: screenSize, video: $video)
                                        .environment(sharedModel)
                                        .frame(height: screenSize.height * 0.4)
                                        .matchedTransitionSource(id: video.id, in: animation) { config in
                                            config
                                                .background(.clear)
                                                .clipShape(.rect(cornerRadius: 15))
                                        }
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                        }
                        .padding(10)
                    }
                }
                .navigationDestination(for: Video.self) { video in
                    DetailView(video: video, animation: animation)
                        .environment(sharedModel)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .padding(15)
        .background(.ultraThinMaterial)
        .foregroundStyle(.primary)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    ContentView()
}
