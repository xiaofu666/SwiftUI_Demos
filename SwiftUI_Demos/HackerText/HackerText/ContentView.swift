//
//  ContentView.swift
//  HackerText
//
//  Created by Lurich on 2024/5/28.
//

import SwiftUI

struct ContentView: View {
    @State private var trigger: Bool = false
    @State private var text: String = "Hello World!"
    @State private var transitionType: TransitionType = .numericText
    @State private var speed: CGFloat = 0.08
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HackerTextView(
                text: text,
                trigger: trigger,
                transition: transitionType.transition,
                duration: 0.8,
                speed: speed
            )
            .font(.largeTitle.bold())
            .lineLimit(2)
        }
        .padding(15)
        .frame(height: 300)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        List {
            Section {
                Text("Transition")
                    .foregroundStyle(.gray)
                
                Picker(selection: $transitionType) {
                    ForEach(TransitionType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                } label: {
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)
                
                Divider()
                    .listRowSeparator(.hidden)
                
                Text("Speed")
                    .foregroundStyle(.gray)
                
                Slider(value: $speed, in: 0.01...0.15, step: 0.01)
                    .listRowSeparator(.hidden)

            }
            
            Button {
                if text == "Hello World!" {
                    text = "This is Hacker\nText View"
                }
                else if text == "This is Hacker\nText View" {
                    text = "Made With SwiftUI\nBy @Lurich"
                }
                else {
                    text = "Hello World!"
                }
                trigger.toggle()
            } label: {
                Text("Trigger")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
        }
    }
    
    enum TransitionType: String, CaseIterable {
        case identity = "Identity"
        case interpolate = "Interpolate"
        case numericText = "NumericText"
        
        var transition: ContentTransition {
            switch self {
            case .identity:
                return .identity
            case .interpolate:
                return .interpolate
            case .numericText:
                return .numericText()
            }
        }
    }
}

#Preview {
    ContentView()
}
