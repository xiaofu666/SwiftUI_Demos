//
//  ContentView.swift
//  HeroNavigationStack
//
//  Created by Xiaofu666 on 2024/11/18.
//

import SwiftUI

struct ContentView: View {
    @State private var config: HeroConfiguration = .init()
    @State private var selectedProfile: Profile?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(profiles) { profile in
                    ProfileViewCard(profile: profile, config: $config) { rect in
                        config.coordinates.0 = rect
                        config.coordinates.1 = rect
                        config.layer = profile.profilePicture
                        config.activeID = profile.id
                        selectedProfile = profile
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationDestination(item: $selectedProfile) { profile in
                DetailView(selectedProfile: $selectedProfile, profile: profile, config: $config)
            }
        }
        .overlay(alignment: .topLeading) {
            ZStack {
                if let image = config.layer {
                    let destination = config.coordinates.1
                    
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: destination.width, height: destination.height)
                        .clipShape(.circle)
                        .offset(x: destination.minX, y: destination.minY)
                        .transition(.identity)
                        .onDisappear() {
                            config = .init()
                        }
                }
            }
            .animation(.snappy(duration: 0.3), value: config.coordinates.1)
            .ignoresSafeArea()
            .opacity(config.isExpandedCompletely ? 0 : 1)
            .onChange(of: selectedProfile == nil) { oldValue, newValue in
                if newValue {
                    config.isExpandedCompletely = false
                    
                    withAnimation(.easeInOut(duration: 0.35), completionCriteria: .logicallyComplete) {
                        config.coordinates.1 = config.coordinates.0
                    } completion: {
                        config.layer = nil
                    }
                }
            }
        }
    }
}

struct ProfileViewCard: View {
    var profile: Profile
    @Binding var config: HeroConfiguration
    var onClick: (CGRect) -> ()
    @State private var viewRect: CGRect = .zero
    
    var body: some View {
        Button {
            onClick(viewRect)
        } label: {
            HStack(spacing: 12) {
                Image(profile.profilePicture)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .opacity(profile.id == config.activeID ? 0 : 1)
                    .clipShape(.circle)
                    .onGeometryChange(for: CGRect.self) { proxy in
                        proxy.frame(in: .global)
                    } action: { newValue in
                        viewRect = newValue
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.userName)
                        .font(.callout)
                        .foregroundStyle(.primary)
                    
                    Text(profile.lastMsg)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .contentShape(.rect)
        }
        .tint(.secondary)
    }
}

struct HeroConfiguration {
    var layer: String?
    var coordinates: (CGRect, CGRect) = (.zero, .zero)
    var isExpandedCompletely: Bool = false
    var activeID: String = ""
}

struct DetailView: View {
    @Binding var selectedProfile: Profile?
    var profile: Profile
    @Binding var config: HeroConfiguration
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(messages) { message in
                    MessageCardView(message: message)
                }
            }
            .padding(15)
        }
        .safeAreaInset(edge: .top) {
            CustomHeaderView()
        }
        .hideNavBarBackground()
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                config.isExpandedCompletely = true
            }
        }
    }
    
    @ViewBuilder
    func CustomHeaderView() -> some View {
        VStack(spacing: 6) {
            ZStack {
                if selectedProfile != nil {
                    Image(profile.profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        .opacity(config.isExpandedCompletely ? 1 : 0)
                        .onGeometryChange(for: CGRect.self) { proxy in
                            proxy.frame(in: .global)
                        } action: { newValue in
                            config.coordinates.1 = newValue
                        }
                        .transition(.identity)
                }
            }
            .frame(width: 50, height: 50)
            
            Button {
                
            } label: {
                HStack(spacing: 2) {
                    Text(profile.userName)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                }
                .font(.caption)
                .foregroundStyle(.primary)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, -25)
        .padding(.bottom, 15)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

struct MessageCardView: View {
    var message: Message
    
    var body: some View {
        Text(message.message)
            .padding(10)
            .foregroundStyle(message.isReply ? Color.primary : .white)
            .background {
                if message.isReply {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.blue.gradient)
                }
            }
            .frame(maxWidth: 250, alignment: message.isReply ? .leading : .trailing)
            .frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
    }
}

extension View {
    @ViewBuilder
    func hideNavBarBackground() -> some View {
        if #available(iOS 18.0, *) {
            self
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        } else {
            self
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
