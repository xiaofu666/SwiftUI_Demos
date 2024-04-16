//
//  ContentView.swift
//  MapsBottomSheetV2
//
//  Created by Lurich on 2024/2/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var activeTab: Tab = .devices
    @State private var showSheet: Bool = false
    @State private var ignoreTabBar: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(initialPosition: .region(.applePark))
            
            TabBar()
                .frame(height: 49)
                .background(.regularMaterial)
        }
        .task {
            showSheet = true
        }
        .sheet(isPresented: $showSheet, content: {
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(activeTab.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Toggle("Ignore Tab Bar", isOn: $ignoreTabBar)
                })
                .padding()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(60), .medium, .large])
            .presentationCornerRadius(20)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            .bottomMaskForSheet(mask: !ignoreTabBar)
        })
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    activeTab = tab
                }, label: {
                    VStack(spacing: 2) {
                        Image(systemName: tab.symbol)
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(activeTab == tab ? Color.accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                })
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    ContentView()
}


enum Tab: String,CaseIterable {
    case people = "People"
    case devices = "Devices"
    case items = "Items"
    case me = "Me"
    var symbol: String {
        switch self {
        case .people:
            "figure.2.arms.open"
        case .devices:
            "macbook.and.iphone"
        case .items:
            "circle.grid.2x2.fill"
        case .me:
            "person.circle.fill"
        }
    }
}

extension MKCoordinateRegion {
    static var applePark: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: 37.334606, longitude: -122.009102)
        return .init(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}
