//
//  ContentView.swift
//  ManualOrientation
//
//  Created by Xiaofu666 on 2025/1/26.
//

import SwiftUI

enum Orientation: String, CaseIterable {
    case all = "All"
    case portrait = "portrait"
    case landscapeLeft = "Left"
    case landscapeRight = "Right"
    
    var mask: UIInterfaceOrientationMask {
        switch self {
        case .all:
            return .all
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        }
    }
}
    
struct ContentView: View {
    @State private var orientation: Orientation = .portrait
    @State private var showFullScreenCover: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Orientation") {
                    /// Regular SegmentedPicker
                    Picker("", selection: $orientation) {
                        ForEach(Orientation.allCases, id: \.rawValue) { orientation in
                            Text(orientation.rawValue)
                                .tag(orientation)
                        }
                    }
                    .pickerStyle (.segmented)
                    .onChange(of: orientation, initial: true) { oldValue, newValue in
                        modifyOrientation(newValue.mask)
                    }
                }
                
                Section("Actions") {
                    NavigationLink("Detail View") {
                        DetailView(userSelection: orientation)
                    }
                    
                    Button("Show Full Screen Cover") {
                        modifyOrientation(.landscapeRight)
                        
                        DispatchQueue.main.async {
                            showFullScreenCover.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Manual Orientation")
            .fullScreenCover(isPresented: $showFullScreenCover) {
                Rectangle()
                    .fill(.red.gradient)
                    .overlay {
                        Text("Hello From Full Screen View!")
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .topTrailing) {
                        Button("Close") {
                            modifyOrientation(orientation.mask)
                            showFullScreenCover.toggle()
                        }
                        .padding(15)
                    }
            }
        }
    }
}

struct DetailView: View {
    var userSelection: Orientation
    @Environment(\.dismiss) private var dismiss
    @State private var isRotated: Bool = false
    
    var body: some View {
        VStack {
            Text("Hello From Detail View!")
            
            Button("Back") {
                modifyOrientation(userSelection.mask)
                
                DispatchQueue.main.async {
                    dismiss()
                }
            }
            
            NavigationLink("Sub-Detail View") {
                Text("Hello From Sub-Detail View!")
                    .onAppear {
                        modifyOrientation(.portrait)
                    }
                    .onDisappear {
                        modifyOrientation(.landscapeLeft)
                    }
            }
        }
        .onAppear {
            guard !isRotated else { return }
            modifyOrientation(.landscapeLeft)
            isRotated = true
        }
        .onDisappear {
            modifyOrientation(userSelection.mask)
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    /// Easy to use function to update orientation anywhere in view scope
    func modifyOrientation(_ mask: UIInterfaceOrientationMask) {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            /// Finally Limiting the auto-rotation by setting orientation mask on AppDelegate
            AppDelegate.orientation = mask
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
            /// Updating Root View Controller
            windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
