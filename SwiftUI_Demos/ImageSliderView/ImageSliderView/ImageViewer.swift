//
//  ImageViewer.swift
//  ImageSliderView
//
//  Created by Xiaofu666 on 2024/12/23.
//

import SwiftUI

struct ImageViewer<Content: View, Overlay: View>: View {
    var config: Config = .init()
    @ViewBuilder var content: Content
    @ViewBuilder var overlay: Overlay
    var updates: (Bool, AnyHashable?) -> () = { _, _ in }
    @State private var isPresented: Bool = false
    @State private var activeTabID: Subview.ID?
    @State private var transitionSource: Int = 0
    //正方形分割列数
    private let count = 2
    @Namespace private var animation
    
    var body: some View {
        Group(subviews: content) { collection in
            LazyVGrid(columns: Array(repeating: GridItem(spacing: config.spacing), count: count), spacing: config.spacing) {
                let remainingCount = max(collection.count - count * count, 0)
                ForEach(collection.prefix(count * count)) { item in
                    let index = collection.index(item.id)
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        item
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: config.cornerRadius))
                        
                        if remainingCount > 0, collection.prefix(count * count).last?.id == item.id {
                            RoundedRectangle(cornerRadius: config.cornerRadius)
                                .fill(.black.opacity(0.35))
                                .overlay {
                                    Text("+\(remainingCount)")
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .frame(height: config.height)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        activeTabID = item.id
                        isPresented = true
                        transitionSource = index
                    }
                    .matchedTransitionSource(id: index, in: animation) { config in
                        config
                            .clipShape(.rect(cornerRadius: self.config.cornerRadius))
                    }
                }
            }
            .navigationDestination(isPresented: $isPresented) {
                TabView(selection: $activeTabID) {
                    ForEach(collection) { item in
                        item
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tag(item.id)
                    }
                }
                .tabViewStyle(.page)
                .background {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                }
                .overlay {
                    overlay
                }
                .navigationTransition(.zoom(sourceID: transitionSource, in: animation))
                .toolbarVisibility(.hidden, for: .navigationBar)
            }
            .onChange(of: activeTabID) { oldValue, newValue in
                transitionSource = min(collection.index(newValue), count * count - 1)
                sendUpdate(collection, id: newValue)
            }
            .onChange(of: isPresented) { oldValue, newValue in
                sendUpdate(collection, id: activeTabID)
            }
        }
    }
    
    private func sendUpdate(_ collection: SubviewsCollection, id: Subview.ID?) {
        if let viewID = collection.first(where: { $0.id == id })?.containerValues.activeViewID {
            updates(isPresented, viewID)
        }
    }
}

struct Config {
    var height: CGFloat = 150
    var cornerRadius: CGFloat = 15
    var spacing: CGFloat = 10
}

extension SubviewsCollection {
    func index(_ id: SubviewsCollection.Element.ID?) -> Int {
        firstIndex(where: { $0.id == id }) ?? 0
    }
}

extension ContainerValues {
    @Entry var activeViewID: AnyHashable?
}

#Preview {
    ContentView()
}
