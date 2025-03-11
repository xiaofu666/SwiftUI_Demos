//
//  ChipsView.swift
//  ChipSelection
//
//  Created by Xiaofu666 on 2025/3/11.
//

import SwiftUI

struct ChipsView<Content: View, Tag: Equatable>: View where Tag: Hashable {
    var spacing: CGFloat = 10
    var animation: Animation = .easeInOut(duration: 0.2)
    var tags: [Tag]
    @ViewBuilder var content: (Tag, Bool) -> Content
    var didChangeSelection: ([Tag]) -> ()
    
    @State private var selectedTags: [Tag] = []
    
    var body: some View {
        CustomChipLayout(spacing: spacing) {
            ForEach(tags, id: \.self) { tag in
                content(tag, selectedTags.contains(tag))
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(animation) {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll(where: { tag == $0 })
                            } else {
                                selectedTags.append(tag)
                            }
                        }
                        didChangeSelection(selectedTags)
                    }
            }
        }
    }
}

fileprivate struct CustomChipLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return .init(width: proposal.width ?? 0, height: maxHeight(proposal: proposal, subviews: subviews))
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)
            if (origin.x + fitSize.width) > bounds.maxX {
                origin.x = bounds.minX
                origin.y += fitSize.height + spacing
                subview.place(at: origin, proposal: proposal)
                origin.x += fitSize.width + spacing
            } else {
                subview.place(at: origin, proposal: proposal)
                origin.x += fitSize.width + spacing
            }
        }
    }
    
    private func maxHeight(proposal: ProposedViewSize, subviews: Subviews)-> CGFloat {
        var origin: CGPoint = .zero
        for subview in subviews {
            let fitSize = subview.sizeThatFits(proposal)
            if (origin.x + fitSize.width) > (proposal.width ?? 0) {
                origin.x = 0
                origin.y += fitSize.height + spacing
            }
            origin.x += fitSize.width + spacing
            
            if subview == subviews.last {
                origin.y += fitSize.height
            }
        }
        return origin.y
    }

}
    
#Preview {
    ContentView()
}
