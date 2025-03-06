//
//  ContentView.swift
//  SystemTray
//
//  Created by Xiaofu666 on 2025/3/6.
//

import SwiftUI

enum CurrentView {
    case actions
    case periods
    case keypad
}


struct ContentView: View {
    @State private var show: Bool = false
    @State private var currentView: CurrentView = .actions
    @State private var selectedAction: Action?
    @State private var selectedPeriod: Period?
    @State private var duration: String = ""
    
    var body: some View {
        Button("Show Tray View") {
            show.toggle()
        }
        .systemTrayView($show) {
            VStack(spacing: 20) {
                ZStack {
                    switch currentView {
                    case .actions: View1()
                            .transition(.blurReplace)
                    case .periods: View2()
                            .transition(.blurReplace)
                    case .keypad: View3()
                            .transition(.blurReplace)
                    }
                }
                .compositingGroup()
                
                /// Continue Button
                Button {
                    withAnimation(.bouncy) {
                        currentView = .periods
                    }
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .foregroundStyle(.white)
                        .background(.blue, in: .capsule)
                }
                .padding(.top, 15)
            }
            .padding(20)
        }
    }
    
    /// View 1
    @ViewBuilder
    func View1() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Choose Subscription")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    show = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(8.1))
                }
            }
            .padding(.bottom, 10)
            
            /// Custom Checkbox Menu
            ForEach(actions) { action in
                let isSelected: Bool = (selectedAction?.id == action.id)
                
                HStack(spacing: 10) {
                    Image(systemName: action.image)
                        .font(.title)
                        .frame(width: 40)
                    
                    Text(action.title)
                        .fontWeight(.semibold)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                        .font(.title)
                        .contentTransition(.symbolEffect)
                        .foregroundStyle(isSelected ? Color.blue : Color.gray.opacity(0.2))
                        .padding(.vertical, 6)
                        .contentShape(.rect)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedAction = isSelected ? nil : action
                            }
                        }
                }
            }
        }
    }
    
    /// View 2
    @ViewBuilder
    func View2() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Choose Period")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation(.bouncy) {
                        currentView = .actions
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(8.1))
                }
            }
            .padding(.bottom, 25)
            
            Text("Choose the period you want\nto get subscribed.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
            
            /// Grid Box View
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 15) {
                ForEach(periods) { period in
                    let isSelected = selectedPeriod?.id == period.id
                    VStack(spacing: 6) {
                        Text(period.title)
                            .font(period.value == 0 ? .title3 : .title2)
                            .fontWeight(.semibold)
                        
                        if period.value != 0 {
                            Text(period.value == 1 ? "Month" : "Months")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:80)
                    .background {
                        RoundedRectangle(cornerRadius:20)
                            .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if period.value == 0 {
                                /// Go To Custom Keypad View(View 3)
                                currentView = .keypad
                            } else {
                                selectedPeriod=isSelected ? nil : period
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    /// View 3
    @ViewBuilder
    func View3() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Custom Duration")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation(.bouncy) {
                        currentView = .periods
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(8.1))
                }
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 6) {
                Text(duration.isEmpty ? "0" : duration)
                    .font(.system(size: 60, weight: .black))
                    .contentTransition(.numericText())
                
                Text("Days")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 20)
            
            /// Custom Keypad View
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 15) {
                ForEach(keypadValues) { keyValue in
                    Button {
                        withAnimation(.snappy){
                            if keyValue.isBack {
                                if !duration.isEmpty {
                                    duration.removeLast()
                                }
                            }
                            else if keyValue.title == "0" {
                                if !duration.isEmpty {
                                    duration.append(keyValue.title)
                                }
                            }
                            else {
                                duration.append(keyValue.title)
                            }
                        }
                    } label: {
                        Group {
                            if keyValue.isBack {
                                Image(systemName: keyValue.title)
                            } else {
                                Text(keyValue.title)
                            }
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .contentShape(.rect)
                    }
                    .buttonStyle(KeypadButtonStyle())
                }
            }
            .padding(.horizontal, -15)
        }
    }
}

/// Custom Button Style for Keypad Buttons
struct KeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.2))
                    .opacity(configuration.isPressed ? 1 : 0)
                    .padding(.horizontal, 5)
            }
            .animation(.easeInOut(duration: 0.25), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
