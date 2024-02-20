//
//  ContentView.swift
//  DraggableMapPin
//
//  Created by Lurich on 2024/2/20.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var camera: MapCameraPosition = .region(.init(center: .applePark, span: .initialSpan))
    @State private var coordinate: CLLocationCoordinate2D = .applePark
    @State private var mapSpan: MKCoordinateSpan = .initialSpan
    @State private var annotationTitle: String = ""
    @State private var updatesCamera: Bool = false
    @State private var displaysTitle: Bool = false
    
    var body: some View {
        MapReader { proxy in
            Map(position: $camera) {
                Annotation(displaysTitle ? annotationTitle : "", coordinate: coordinate) {
                    DraggablePin(proxy: proxy, coordinate: $coordinate) { coordinate in
                        findCoordinateName()
                        guard updatesCamera else { return }
                        let newRegion = MKCoordinateRegion(center: coordinate, span: mapSpan)
                        withAnimation(.smooth) {
                            camera = .region(newRegion)
                        }
                    }
                }
            }
            .onMapCameraChange(frequency: .continuous) { context in
                mapSpan = context.region.span
            }
            .safeAreaInset(edge: .bottom, content: {
                HStack(spacing: 0, content: {
                    Toggle("Updates Camera", isOn: $updatesCamera)
                        .frame(width: 170)
                    
                    Spacer()
                    
                    Toggle("Displays Title", isOn: $displaysTitle)
                        .frame(width: 150)
                })
                .textScale(.secondary)
                .padding(15)
                .background(.ultraThinMaterial)
            })
            .onAppear(perform: findCoordinateName)
        }
    }
    
    func findCoordinateName() {
        annotationTitle = ""
        Task {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            print(coordinate.latitude,coordinate.longitude)
            let geoDecoder = CLGeocoder()
            do {
                if let name = try await geoDecoder.reverseGeocodeLocation(location).first?.name {
                    annotationTitle = name
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}

struct DraggablePin: View {
    var tint: Color = .red
    var proxy: MapProxy
    @Binding var coordinate: CLLocationCoordinate2D
    var onCoordinateChange: (CLLocationCoordinate2D) -> ()
    
    @State private var isActive: Bool = false
    @State private var translation: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            Image(systemName: "mappin")
                .font(.title)
                .foregroundStyle(tint.gradient)
                .animation(.snappy, body: { content in
                    content
                        .scaleEffect(isActive ? 1.3 : 1, anchor: .bottom)
                })
                .frame(width: frame.width, height: frame.height)
                .onChange(of: isActive, initial: false) { oldValue, newValue in
                    let position = CGPoint(x: frame.midX, y: frame.midY)
                    if let coordinate = proxy.convert(position, from: .global), !newValue {
                        self.coordinate = coordinate
                        translation = .zero
                        onCoordinateChange(coordinate)
                    }
                }
        }
        .frame(width: 30, height: 30)
        .contentShape(.rect)
        .offset(translation)
        .gesture(
            LongPressGesture(minimumDuration: 0.15)
                .onEnded { _ in
                    isActive = true
                }
                .simultaneously(with:
                    DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if isActive {
                            translation = value.translation
                        }
                    }
                    .onEnded { value in
                        if isActive {
                            isActive = false
                        }
                    }
                )
            
        )
    }
}

extension MKCoordinateSpan {
    static var initialSpan: MKCoordinateSpan {
        return .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}

extension CLLocationCoordinate2D {
    static var applePark: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 39.917700, longitude: 116.396950)
    }
}
