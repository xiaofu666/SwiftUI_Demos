//
//  ContentView.swift
//  CustomScrollInteraction
//
//  Created by Xiaofu666 on 2025/2/25.
//

import SwiftUI

struct ContactSection: Identifiable {
    var id: String
    var contacts: [Contact]
    
    static func generateData() -> [ContactSection] {
        Dictionary(grouping: dummyContacts, by: { String($0.name.first ?? "A") }).compactMap({ .init(id: $0.key, contacts: $0.value) }).sorted(by: { $0.id < $1.id })
    }
}

struct ContentView: View {
    @State private var sections: [ContactSection] = ContactSection.generateData()
    @State private var scrollProperties: ScrollGeometry = .init(
        contentOffset: .zero,
        contentSize: .zero,
        contentInsets: .init(),
        containerSize: .zero
    )
    @State private var scrollPhase: ScrollPhase = .idle
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var previousScrollProgress: CGFloat?
    @GestureState private var isGestureActive: Bool = false
    @State private var activeID: String = "A"
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 12) {
                    ForEach(sections) { section in
                        SectionView(section: section)
                    }
                }
                .padding(20)
                .padding(.bottom, scrollProperties.containerSize.height - 250)
            }
            .background(.gray.opacity(0.15))
            .navigationTitle("Contacts")
            .scrollIndicators(.hidden)
            .onScrollGeometryChange(for: ScrollGeometry.self, of: { $0 }) { oldValue, newValue in
                scrollProperties = newValue
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                scrollPhase = newPhase
            }
            .scrollPosition($scrollPosition)
        }
        .overlay(alignment: .trailing) {
            CustomScrollIndicator()
        }
    }
    
    @ViewBuilder
    func SectionView(section: ContactSection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.id)
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(section.contacts) { contact in
                    Text(contact.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    /// 避免为最后一项设置分隔符
                    if contact.id != section.contacts.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(15)
        .background(.background, in: .rect(cornerRadius: 10))
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .scrollView(axis: .vertical))
        } action: { newValue in
            if newValue.minY >= 0 && newValue.minY < 150 {
                activeID = section.id
            }
        }

    }
    
    /// 自定义滚动指示器
    func CustomScrollIndicator() -> some View {
        GeometryReader { geometry in
            let indicatorHeight: CGFloat = 40
            let scrollProgress = max(min(scrollProperties.scrollOffsetY / scrollProperties.contentHeight, 1.0), 0.0)
            let indicatorOffset = (geometry.size.height - indicatorHeight) * scrollProgress
            let showPopup = scrollPhase != .idle || isGestureActive
            
            ZStack(alignment: .top) {
                Capsule()
                    .fill(.background.shadow(.drop(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)))
                    .padding(.trailing, 5)
                
                Capsule()
                    .fill(.blue.gradient)
                    .frame(height: indicatorHeight)
                    .padding(.trailing, 5)
                    .highPriorityGesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("INDICATOR_VIEW"))
                            .updating($isGestureActive) { _, out, _ in
                                out = true
                            }
                            .onChanged { value in
                                if previousScrollProgress == nil {
                                    previousScrollProgress = scrollProgress
                                }
                                guard let previousScrollProgress else { return }
                                /// Calculating Drag Progress
                                let dragProgress = value.translation.height / (geometry.size.height - indicatorHeight)
                                let endProgress = max(min(previousScrollProgress + dragProgress, 1), 0)
                                /// Scrolling Content
                                scrollPosition.scrollTo(y: endProgress * scrollProperties.contentHeight)
                            }
                    )
                    .offset(y: indicatorOffset)
                    .onChange(of: isGestureActive) { oldValue, newValue in
                        if !newValue {
                            previousScrollProgress = nil
                        }
                    }
            }
            .overlay(alignment: .topLeading) {
                ZStack {
                    if showPopup {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 50,
                            bottomLeadingRadius: 50,
                            bottomTrailingRadius: 5,
                            topTrailingRadius: 50,
                            style: .continuous
                        )
                        .fill(.blue.gradient)
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text(activeID)
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        }
                        .compositingGroup()
                        .offset(x: -55, y: indicatorOffset - 10)
                    }
                }
                .offset(y: isGestureActive ? -50 : 0)
                .animation(.easeInOut(duration: 0.25), value: isGestureActive)
            }
            .animation(.easeInOut(duration: 0.25), value: showPopup)
        }
        .frame(width: 13)
        .containerRelativeFrame(.vertical) { value, _ in
            value * 0.5
        }
        .coordinateSpace(name: "INDICATOR_VIEW")
    }
}

#Preview {
    ContentView()
}

extension ScrollGeometry {
    var scrollOffsetY: CGFloat {
        contentOffset.y + contentInsets.top
    }
    
    var contentHeight: CGFloat {
        contentSize.height - containerSize.height
    }
}
