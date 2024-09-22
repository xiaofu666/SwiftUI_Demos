//
//  ChipsView.swift
//  ChipsUI
//
//  Created by Xiaofu666 on 2024/9/22.
//

import SwiftUI

struct ChipsView<Content: View>: View {
    let width: CGFloat
    @ViewBuilder var content: Content
    
    var body: some View {
        Group(subviews: content) { collection in
            let spacing: CGFloat = 10
            let chunkedCollection = collection.chunkByWidth(width, spacing: spacing)
            
            VStack(alignment: .center, spacing: spacing) {
                ForEach(chunkedCollection.indices, id: \.self) { index in
                    HStack(spacing: spacing) {
                        ForEach(chunkedCollection[index]) { subView in
                            subView
                        }
                    }
                }
            }
        }
    }
}

extension SubviewsCollection {
    func chunkByWidth(_ containerWidth: CGFloat, spacing: CGFloat) -> [[Subview]] {
        var row: [Subview] = []
        var rowWidth: CGFloat = 0
        var rows: [[Subview]] = []
        
        for subView in self {
            let viewWidth = subView.containerValues.viewWidth + spacing
            rowWidth += viewWidth
            
            if rowWidth < containerWidth {
                row.append(subView)
            } else {
                rows.append(row)
                row = [subView]
                rowWidth = viewWidth
            }
        }
        if !row.isEmpty {
            rows.append(row)
        }
        return rows
    }
    
    func chunked(_ size: Int) -> [[Subview]] {
        return stride(from: 0, to: count, by: size).map { index in
            Array(self[index ..< Swift.min(index + size, count)])
        }
    }
}

#Preview {
    ContentView()
}
