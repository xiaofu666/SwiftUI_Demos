//
//  Home.swift
//  PhotosApp
//
//  Created by Lurich on 2024/5/12.
//

import SwiftUI

struct Home: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        NavigationStack {
            @Bindable var bindableCoordinator = coordinator
            ScrollViewReader { reader in
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        Text("Recents")
                            .font(.largeTitle.bold())
                            .padding(.bottom, 10)
                            .padding([.top, .horizontal], 15)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 3), count: 3), spacing: 3) {
                            ForEach($bindableCoordinator.items) { $item in
                                GridImageView(item)
                                    .id(item.id)
                                    .didFrameChange { frame, bounds in
                                        let minY = frame.minY
                                        let maxY = frame.maxY
                                        let height = bounds.height
                                        if maxY < 0 || minY > height {
                                            item.appeared = false
                                        } else {
                                            item.appeared = true
                                        }
                                    }
                                    .onDisappear() {
                                        item.appeared = false
                                    }
                                    .onTapGesture {
                                        coordinator.selectedItem = item
                                    }
                            }
                        }
                    }
                }
                .onChange(of: coordinator.selectedItem) { oldValue, newValue in
                    if let item = newValue, !item.appeared {
                        reader.scrollTo(item.id, anchor: .bottom)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .allowsHitTesting(coordinator.selectedItem == nil)
        }
        .overlay {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(coordinator.animateView ? 1 - coordinator.dragProgress : 0)
        }
        .overlay {
            if coordinator.selectedItem != nil {
                Detail()
                    .allowsHitTesting(coordinator.showDetailView)
            }
        }
        .overlayPreferenceValue(HeroKey.self) { value in
            if let selectedItem = coordinator.selectedItem,
               let sAnchor = value[selectedItem.id + "SOURCE"],
               let dAnchor = value[selectedItem.id + "DEST"] {
                HeroLayer(item: selectedItem, sAnchor: sAnchor, dAnchor: dAnchor)
            }
        }
    }
    
    @ViewBuilder
    func GridImageView(_ item: Item) -> some View {
        GeometryReader {
            let size = $0.size
            
            Rectangle()
                .fill(.clear)
                .anchorPreference(key: HeroKey.self, value: .bounds) { anchor in
                    [item.id + "SOURCE": anchor]
                }
            
            if let previewImage = item.previewImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .opacity(coordinator.selectedItem?.id == item.id ? 0 : 1)
            }
        }
        .frame(height: 130)
        .contentShape(.rect)
    }
}

#Preview {
    ContentView()
}
