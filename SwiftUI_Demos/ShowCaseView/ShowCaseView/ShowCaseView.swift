//
//  ShowCaseView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/5/14.
//

import SwiftUI
import MapKit

@available(iOS 16.4, *)
struct ShowCaseView: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.542692, longitude: 116.232693), latitudinalMeters: 1000, longitudinalMeters: 1000)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            GeometryReader {
                let safeGrea = $0.safeAreaInsets
                
                Map(coordinateRegion: $region)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .frame(height: safeGrea.top)
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        VStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.black)
                                    }
                            }
                            .showCase(order: 0, title: "My Current Location", cornerRadius: 10, style: .continuous)
                            
                            Spacer(minLength: 0)
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.red)
                                    }
                            }
                            .showCase(order: 1, title: "Favourite Location's", cornerRadius: 10, style: .continuous)
                        }
                        .padding(15)
                    }
                    .overlay(alignment: .topLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .padding(10)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.black)
                                }
                        }
                        .showCase(order: 5, title: "Back", cornerRadius: 10, style: .continuous)
                        .padding(15)
                    }
            }
            .tabItem {
                Image(systemName: "macbook.and.iphone")
                Text("Devices")
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            
            Text("")
                .tabItem {
                    Image(systemName: "macbook.and.iphone")
                    Text("Items")
                }
            
            Text("")
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Me")
                }
        }
        .overlay(alignment: .bottom, content: {
            HStack(alignment: .bottom) {
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(order: 2, title: "Map In My Device's", cornerRadius: 30, style: .continuous, scale: 1.5)
                    .frame(maxWidth: .infinity)
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(order: 3, title: "Location Enabled Tag's", cornerRadius: 30, style: .continuous, scale: 1.5)
                    .frame(maxWidth: .infinity)
                Circle()
                    .frame(width: 45, height: 45)
                    .showCase(order: 4, title: "Personal Info", cornerRadius: 30, style: .continuous, scale: 1.5)
                    .frame(maxWidth: .infinity)
            }
            .allowsHitTesting(false)
            .foregroundColor(.clear)
        })
        .modifier(ShowCaseRoot(showHighlights: true, onFinished: {
            print("finished")
        }))
    }
}

@available(iOS 16.4, *)
struct ShowCaseView_Previews: PreviewProvider {
    static var previews: some View {
        ShowCaseView()
    }
}

/// Highlight View Properties
struct HighlightModel: Identifiable, Equatable {
    var id: UUID = .init()
    var anchor: Anchor<CGRect>
    var title: String
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
}

extension View {
    @ViewBuilder
    func showCase(order: Int, title: String, cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat = 1) -> some View {
        self
            .anchorPreference(key: HighlightAnchorKey.self, value: .bounds) { anchor in
                let highlight = HighlightModel(anchor: anchor, title: title, cornerRadius: cornerRadius, style: style, scale: scale)
                return [order: highlight]
            }
    }
}

fileprivate struct HighlightAnchorKey: PreferenceKey {
    typealias Value = [Int: HighlightModel]
    static var defaultValue: Value = [:]
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

@available(iOS 16.4, *)
struct ShowCaseRoot: ViewModifier {
    var showHighlights: Bool
    var onFinished: () -> ()
    @State private var highlightOrder: [Int] = []
    @State private var currentHighlight: Int = 0
    @State private var showView: Bool = true
    @State private var showTitle: Bool = false
    @Namespace private var animation
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(HighlightAnchorKey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorKey.self) { preference in
                if highlightOrder.indices.contains(currentHighlight), showHighlights, showView {
                    if let highlight = preference[highlightOrder[currentHighlight]] {
                        HighlightView(highlight)
                    }
                }
            }
    }
    
    @ViewBuilder
    func HighlightView(_ highlight: HighlightModel) -> some View {
        GeometryReader { proxy in
            let highlightRect = proxy[highlight.anchor]
            let safeArea = proxy.safeAreaInsets
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .reverseMask(alignment: .topLeading) {
                    Rectangle()
                        .matchedGeometryEffect(id: "HIGHLIGHT_SHAPE", in: animation)
                        .frame(width: highlightRect.width + 5, height: highlightRect.height + 5)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .scaleEffect(highlight.scale)
                        .offset(x: highlightRect.minX - 2.5, y: safeArea.top + highlightRect.minY - 2.5)
                }
                .ignoresSafeArea()
                .onTapGesture {
                    if currentHighlight >= highlightOrder.count - 1 {
                        // remove this highlight view
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showView = false
                        }
                        onFinished()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.7)) {
                            showTitle = false
                            currentHighlight += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            showTitle = true
                        }
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showTitle = true
                    }
                }
            
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: highlightRect.width + 20, height: highlightRect.height + 20)
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .popover(isPresented: $showTitle, content: {
                    Text(highlight.title)
                        .padding(.horizontal, 10)
                        .presentationCompactAdaptation(.popover)
                        .interactiveDismissDisabled()
                })
                .scaleEffect(highlight.scale)
                .offset(x: highlightRect.minX - 10, y: highlightRect.minY - 10)
        }
    }
}

extension View {
    
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}
