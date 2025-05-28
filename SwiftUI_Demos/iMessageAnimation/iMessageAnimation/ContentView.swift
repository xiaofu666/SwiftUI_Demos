//
//  ContentView.swift
//  iMessageAnimation
//
//  Created by Xiaofu666 on 2025/5/28.
//

import SwiftUI

struct ContentView: View {
    @State private var config: MenuConfig = .init(symbolImage: "plus")
    
    var body: some View {
        CustomMenuView(config: $config) {
            NavigationStack {
                ScrollView(.vertical) {
                    CellView("Hi")
                    CellView("Hello World!")
                    CellView("Lorem lpsum is simply dummy text of the printing and typesetting industry. lorem lpsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. it has survived not only five centuries.")
                }
                .navigationTitle("Message")
                .safeAreaInset(edge: .bottom) {
                    BottomBar()
                }
            }
        } actions: {
            /// Sample Action's
            MenuAction(symbolImage: "camera", text: "Camera")
            MenuAction(symbolImage: "photo.on.rectangle.angled", text: "photos")
            MenuAction(symbolImage: "face.smiling", text: "Genmoji")
            MenuAction(symbolImage: "waveform", text: "Audio")
            MenuAction(symbolImage: "apple.logo", text: "App Store")
            MenuAction(symbolImage: "video.badge.waveform", text: "Facetime")
            MenuAction(symbolImage: "rectangle.and.text.magnifyingglass", text: "#Images")
            MenuAction(symbolImage: "suit.heart", text: "Digital Touch")
            MenuAction(symbolImage: "location", text: "Location")
            MenuAction(symbolImage: "music.note", text: "Music")
        }

    }
    
    @ViewBuilder
    func CellView(_ content: String) -> some View {
        Text(content)
            .font(.body)
            .fontWeight(.regular)
            .padding(15)
            .foregroundStyle(.white)
            .background(.green)
            .clipShape(.rect(cornerRadius: 15, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 15)
            .padding(.leading, 75)
    }
    
    // Custom Bottom Bar
    func BottomBar() -> some View {
        HStack(spacing: 12) {
            MenuSourceButton(config: $config) {
                Image(systemName: "plus")
                    .font(.title3)
                    .frame(width: 35, height: 35)
                    .background {
                        Circle()
                            .fill(.gray.opacity(0.25))
                            .background(.background, in: .circle)
                    }
            } onTap: {
                // Examples:
                // Can close keyboard if opened, etc!
                print("Tapped")
            }
            
            TextField("Text Message", text: .constant(""))
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background {
                    Capsule()
                        .stroke(.gray.opacity(0.3), lineWidth: 1.5)
                }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
}

#Preview {
    ContentView()
}
