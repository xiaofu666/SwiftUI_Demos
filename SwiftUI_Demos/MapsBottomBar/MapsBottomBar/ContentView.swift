//
//  ContentView.swift
//  MapsBottomBar
//
//  Created by Xiaofu666 on 2025/6/29.
//

import SwiftUI
import MapKit

/// Apple Park Coordinates
/// Apple Park Coordinates
extension MKCoordinateRegion {
    static let applePark = MKCoordinateRegion(
        center: .init(
            latitude: 37.3346,
            longitude: -122.0090
        ),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
}
                                          
struct ContentView: View {
    @State private var showBottomBar: Bool = true
    @State private var sheetDetent: PresentationDetent = .height(80)
    
    var body: some View {
        Map(initialPosition: .region(.applePark))
            .sheet(isPresented: $showBottomBar) {
                BottomBarView(selection: $sheetDetent)
                    .presentationDetents([.height(80), .fraction(0.6), .large], selection: $sheetDetent)
                    .presentationBackgroundInteraction(.enabled)
            }
    }
}

#Preview {
    ContentView()
}
