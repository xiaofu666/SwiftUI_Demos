//
//  ElasticScrollView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/6/10.
//

import SwiftUI

@available(iOS 16.0, *)
struct ElasticScrollView: View {
    private let nameID: String = "ElasticScrollView"
    @State private var scrollRect: CGRect = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 18) {
                    ForEach(sampleMessages) { message in
                        MessageRow(message)
                            .elasticScroll(scrollRect: scrollRect, screenSize: size, name: nameID)
                    }
                }
                .padding(15)
                .getRectFor(key: nameID) { rect in
                    scrollRect = rect
                }
            }
            .coordinateSpace(name: nameID)
        }
        .navigationTitle("Message")
        .navigationBarTitleDisplayMode(.large)
    }
    
    @ViewBuilder
    func MessageRow(_ message: MessageModel) -> some View {
        HStack(spacing: 15) {
            Image(message.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(.green.gradient)
                        .frame(width: 15, height: 15)
                        .shadow(color: .primary.opacity(0.1), radius: 5, x: 5, y: 5)
                        .opacity(message.onLine ? 1 : 0)
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(message.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(message.message)
                    .font(.caption)
                    .foregroundColor(message.read ? .gray : .black)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

@available(iOS 16.0, *)
struct ElasticScrollView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ElasticScrollView()
        }
    }
}

@available(iOS 15.0, *)
extension View {
    @ViewBuilder
    func elasticScroll(scrollRect: CGRect, screenSize: CGSize, name: String) -> some View {
        self
            .modifier(ElasticScrollHelper(scrollRect: scrollRect, screenSize: screenSize, name: name))
    }
}
@available(iOS 15.0, *)
fileprivate struct ElasticScrollHelper: ViewModifier {
    var scrollRect: CGRect
    var screenSize: CGSize
    let name: String
    @State private var viewRect: CGRect = .zero
    
    func body(content: Content) -> some View {
        let progress = scrollRect.minY / scrollRect.maxY
        let elasticOffset = (progress * viewRect.minY) * 1.5
        let bottomProgress = max(1 - scrollRect.maxY / screenSize.height, 0)
        let bottomElastic = (bottomProgress * viewRect.maxY) * 1.2
        content
            .offset(y: scrollRect.minY > 0 ? elasticOffset : 0)
            .offset(y: scrollRect.minY > 0 ? -(progress * scrollRect.minY) : 0)
            .offset(y: scrollRect.maxY < screenSize.height ? bottomElastic : 0)
            .getRectFor(key: name) { rect in
                viewRect = rect
            }
    }
}
