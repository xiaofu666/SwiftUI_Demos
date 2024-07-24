//
//  ContentView.swift
//  CoverCarousel
//
//  Created by Xiaofu666 on 2024/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var activeID: UUID?
    @State private var style: Style = .complete
    
    var body: some View {
        NavigationStack {
            VStack {
                CoverCarousel(config: style.config, selection: $activeID, data: images) { item in
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 150)
                .padding(.vertical, 30)
                
                List {
                    Section {
                        Picker("", selection: $style) {
                            ForEach(Style.allCases, id: \.self) { style in
                                Text(style.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Config")
                    }
                }
            }
            .navigationTitle("Cover Carousel")
        }
    }
    
    enum Style: String, CaseIterable {
        case complete = "Complete"
        case opacity = "Opacity"
        case scale = "Scale"
        case both = "Both"
        
        var config: Config {
            switch self {
            case .complete:
                return .init()
            case .opacity:
                return .init(hasOpacity: true)
            case .scale:
                return .init(hasScale: true)
            case .both:
                return .init(hasOpacity: true, hasScale: true)
            }
        }
    }
}

#Preview {
    ContentView()
}
