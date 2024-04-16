//
//  Home.swift
//  ProgressHeroEffect
//
//  Created by Lurich on 2023/10/14.
//

import SwiftUI

struct Home: View {
    @State private var allProfiles: [Profile] = profiles
    @State private var selectedProfile: Profile?
    @State private var showDetail: Bool = false
    @State private var heroProgress: CGFloat = 0
    @State private var showHeroView: Bool = true
    
    var body: some View {
        NavigationStack {
            List(profiles) { profile in
                HStack(spacing: 12) {
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .opacity(selectedProfile?.id == profile.id ? 0 : 1)
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return [profile.id.uuidString: anchor]
                        })
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text(profile.userName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(profile.lastMsg)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    })
                }
                .contentShape(.rect)
                .onTapGesture {
                    selectedProfile = profile
                    showDetail = true
                    
                    withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                        heroProgress = 1.0
                    } completion: {
                        showHeroView = false
                    }

                }
            }
            .navigationTitle("Progress Effect")
        }
        .overlay {
            DetailView(
                selectedProfile: $selectedProfile,
                heroProgress: $heroProgress,
                showHeroView: $showHeroView,
                showDetail: $showDetail
            )
        }
        .overlayPreferenceValue(AnchorKey.self) { value in
            GeometryReader { geometryProxy in
                if let selectedProfile,
                   let source = value[selectedProfile.id.uuidString],
                   let destination = value["DESTINATION"] {
                    let sourceRect = geometryProxy[source]
                    let radius = sourceRect.height / 2
                    let destinationRect = geometryProxy[destination]
                    
                    let diffSize = CGSize(width: destinationRect.width - sourceRect.width, height: destinationRect.height - sourceRect.height)
                    let diffOrigin = CGPoint(x: destinationRect.minX - sourceRect.minX, y: destinationRect.minY - sourceRect.minY)
                    
                    Image(selectedProfile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: sourceRect.width + diffSize.width * heroProgress, height: sourceRect.height + diffSize.height * heroProgress)
                        .clipShape(.rect(cornerRadius: radius - radius * heroProgress))
                        .offset(x: sourceRect.minX + diffOrigin.x * heroProgress, y: sourceRect.minY + diffOrigin.y * heroProgress)
                        .opacity(showHeroView ? 1 : 0)
                }
            }
        }
    }
}

struct DetailView: View {
    @Binding var selectedProfile: Profile?
    @Binding var heroProgress: CGFloat
    @Binding var showHeroView: Bool
    @Binding var showDetail: Bool
    
    @Environment(\.colorScheme) private var scheme
    
    @GestureState private var isDragging: Bool = false
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        if let selectedProfile, showDetail {
            GeometryReader {
                let size = $0.size
                ScrollView(.vertical) {
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if !showHeroView {
                                Image(selectedProfile.profilePicture)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: 400)
                                    .clipped()
                                    .transition(.identity)
                            }
                        }
                        .frame(height: 400)
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                            return ["DESTINATION": anchor]
                        })
                        .visualEffect { content, geometryProxy in
                            content
                                .offset(y: geometryProxy.frame(in: .scrollView).minY > 0 ? -geometryProxy.frame(in: .scrollView).minY : 0)
                        }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea()
                .frame(width: size.width, height: size.height)
                .background() {
                    Rectangle()
                        .fill(scheme == .dark ? .black : .white)
                        .ignoresSafeArea()
                }
                .overlay(alignment: .topLeading) {
                    Button(action: {
                        showHeroView = true
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                            heroProgress = 0.0
                        } completion: {
                            showDetail = false
                            self.selectedProfile = nil
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(Circle())
                            .foregroundStyle(.white, .black)
                    })
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.2, extraBounce: 0), value: showHeroView)
                }
                .offset(x: size.width - size.width * heroProgress)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 20)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : 0
                                    translation = translation > 0 ? translation : 0
                                    let dragProgress = (1 - translation / size.width)
                                    let cappedProgress = min(max(0, dragProgress), 1)
                                    heroProgress = cappedProgress
                                    offset = translation
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                })
                                .onEnded({ value in
                                    let velocity = value.velocity.width
                                    if (offset + velocity) > size.width * 0.8 {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgress = 0.0
                                        } completion: {
                                            showHeroView = true
                                            showDetail = false
                                            offset = .zero
                                            self.selectedProfile = nil
                                        }
                                    } else {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                            heroProgress = 1.0
                                            offset = .zero
                                        } completion: {
                                            showHeroView = false
                                        }
                                    }
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
