//
//  ContentView.swift
//  LimitedTF
//
//  Created by Lurich on 2024/4/1.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    
    @State private var type: String = "Ring"
    @State private var autoResizes: Bool = false
    @State private var allowsExcessTyping: Bool = false
    @State private var radius: CGFloat = 15
    @State private var width: CGFloat = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                LimitedTextField(
                    config: .init(
                        limit: 40,
                        tint: .secondary,
                        autoResizes: autoResizes,
                        allowsExcessTyping: allowsExcessTyping,
                        progressConfig: .init(
                            showsRing: type == "Ring",
                            showsText: type == "Text",
                            alignment: .trailing
                        ),
                        borderConfig: .init(
                            show: radius > 0,
                            radius: radius,
                            width: width
                        )
                    ),
                    hint: "Type here",
                    value: $text
                )
                .autocorrectionDisabled()
                .frame(maxHeight: 150)
                
                List {
                    Section {
                        Picker("indicator type", selection: $type) {
                            Text("Ring")
                                .tag("Ring")
                            Text("Text")
                                .tag("Text")
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("indicator type")
                    }
                    
                    Toggle("autoResizes", isOn: $autoResizes)
                    Toggle("allowsExcessTyping", isOn: $allowsExcessTyping)
                    
                    Section {
                        Slider(value: $radius, in: 0...25)
                    } header: {
                        Text("border radius")
                    }
                    
                    Section {
                        Slider(value: $width, in: 0.5...5)
                    } header: {
                        Text("border width")
                    }

                }
            }
            .padding()
            .navigationTitle("Limited TextField")
        }
    }
}

#Preview {
    ContentView()
}
