//
//  CompositionalLayout.swift
//  CompositionalGridLayout
//
//  Created by Xiaofu666 on 2024/8/7.
//

import SwiftUI

struct CompositionalLayout<Content: View>: View {
    var count: Int = 3
    var spacing: CGFloat = 6
    @ViewBuilder var content: Content
    @Namespace private var animation
    var body: some View {
        Group(subviews: content) { collection in
            let chunked = collection.chunked(count, style: 4)
            
            ForEach(chunked) { chunk in
                switch chunk.layoutID {
                case 0: Layout1(chunk.collection)
                case 1: Layout2(chunk.collection)
                case 2: Layout3(chunk.collection)
                case 3: Layout4(chunk.collection)
                default: EmptyView()
                }
            }
        }
    }
    
    @ViewBuilder
    func Layout1(_ collections: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width - spacing * 2
            
            HStack(spacing: count == 1 ? 0 : spacing) {
                if let first = collections.first {
                    first
                        .matchedGeometryEffect(id: first.id, in: animation)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collections.dropFirst()) { item in
                        item
                            .frame(width: width / 3)
                            .matchedGeometryEffect(id: item.id, in: animation)
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func Layout2(_ collections: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collections) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        }
        .frame(height: 100)
    }
    
    @ViewBuilder
    func Layout3(_ collections: [SubviewsCollection.Element]) -> some View {
        GeometryReader {
            let width = $0.size.width - (count == 1 ? 0 : spacing * 2)
            
            HStack(spacing: spacing) {
                if let first = collections.first {
                    first
                        .frame(width: count == 1 ? width : width / 3)
                        .matchedGeometryEffect(id: first.id, in: animation)
                }
                
                VStack(spacing: spacing) {
                    ForEach(collections.dropFirst()) { item in
                        item
                            .matchedGeometryEffect(id: item.id, in: animation)
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    @ViewBuilder
    func Layout4(_ collections: [SubviewsCollection.Element]) -> some View {
        HStack(spacing: spacing) {
            ForEach(collections) {
                $0
                    .matchedGeometryEffect(id: $0.id, in: animation)
            }
        }
        .frame(height: 200)
    }
}

fileprivate extension SubviewsCollection {
    func chunked(_ size: Int, style num: Int = 1) -> [ChunkedCollection] {
        stride(from: 0, to: count, by: size).map { index in
            let collection = Array(self[index..<Swift.min(index+size, count)])
            let layoutID = index / size % num
            return .init(layoutID: layoutID, collection: collection)
        }
    }
    
    struct ChunkedCollection: Identifiable {
        var id: UUID = .init()
        var layoutID: Int
        var collection: [SubviewsCollection.Element]
    }
}

#Preview {
    ContentView()
}
