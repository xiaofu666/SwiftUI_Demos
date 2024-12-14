//
//  ContentView.swift
//  PaymentCard
//
//  Created by Xiaofu666 on 2024/12/14.
//

import SwiftUI

struct Card: Hashable {
    var name: String = ""
    var number: String = ""
    var cvv: String = ""
    var month: String = ""
    var year: String = ""
}

enum ActiveField {
    case name
    case number
    case cvv
    case month
    case year
}

struct ContentView: View {
    @State private var card: Card = .init()
    @FocusState private var activeField: ActiveField?
    @State private var animateField: ActiveField?
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                if animateField != .cvv {
                    CardFrontView()
                        .transition(.flip)
                } else {
                    CardBackView()
                        .transition(.reverseFlip)
                }
            }
            .frame(height: 200)
            
            CustomTextField(title: "Card Number", hint: "", value: $card.number) {
                card.number = String(card.number.group(" ", count: 4).prefix(19))
            }
            .keyboardType(.numberPad)
            .focused($activeField, equals: .number)
            
            CustomTextField(title: "Card Name", hint: "", value: $card.name) {
                
            }
            .focused($activeField, equals: .name)
            
            HStack(spacing: 10) {
                CustomTextField(title: "Month", hint: "", value: $card.month) {
                    card.month = String(card.month.prefix(2))
                    if card.month.count == 2 {
                        activeField = .year
                    }
                }
                .focused($activeField, equals: .month)
                
                CustomTextField(title: "Year", hint: "", value: $card.year) {
                    card.year = String(card.year.prefix(2))
                }
                .focused($activeField, equals: .year)
                
                CustomTextField(title: "CVV", hint: "", value: $card.cvv) {
                    card.cvv = String(card.cvv.prefix(3))
                }
                .focused($activeField, equals: .cvv)
            }
            .keyboardType(.numberPad)
            
            Spacer()
        }
        .padding()
        .onChange(of: activeField) { oldValue, newValue in
            withAnimation(.snappy) {
                animateField = newValue
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    activeField = nil
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    var rawCardNumber: String {
        card.number.replacingOccurrences(of: " ", with: "")
    }
    
    @ViewBuilder
    func CardFrontView() -> some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1.0, 0),
                .init(0, 0.5), .init(0.9, 0.6), .init(1.0, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [
                .red, .red, .pink,
                .pink, .orange, .red,
                .red, .orange, .red,
            ]
        )
        .clipShape(.rect(cornerRadius: 25))
        .overlay {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("card number".uppercased())
                        .font(.caption)
                    
                    Text(rawCardNumber.dummyText("*", count: 16).group(" ", count: 4))
                        .font(.title2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(AnimatedRing(animateField == .number))
                .frame(maxHeight: .infinity)
                
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("card holder".uppercased())
                            .font(.caption)
                        
                        Text(String(card.name.isEmpty ? "your name" : card.name).uppercased())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(AnimatedRing(animateField == .name))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("expires".uppercased())
                            .font(.caption)
                        
                        HStack(spacing: 4) {
                            Text(card.month.dummyText("M", count: 2))
                            Text("/")
                            Text(card.year.dummyText("Y", count: 2))
                        }
                    }
                    .padding(10)
                    .background(AnimatedRing(animateField == .month || animateField == .year))
                }
            }
            .foregroundStyle(.white)
            .monospaced()
            .contentTransition(.numericText())
            .animation(.snappy, value: card)
            .padding(15)
        }
    }
    
    @ViewBuilder
    func CardBackView() -> some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(.red.mix(with: .blue, by: 0.2))
            .overlay {
                VStack(spacing: 15) {
                    Rectangle()
                        .fill(.black)
                        .frame(height: 45)
                        .padding(.horizontal, -15)
                        .padding(.top, 10)
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("CVV")
                            .font(.caption)
                            .padding(.trailing, 10)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                            .frame(height: 45)
                            .overlay(alignment: .trailing) {
                                Text(card.cvv.dummyText("*", count: 3))
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 15)
                            }
                    }
                    .foregroundStyle(.white)
                    .monospaced()
                    
                    Spacer(minLength: 0)
                }
                .padding(15)
                .contentTransition(.numericText())
                .animation(.snappy, value: card)
            }
    }
    
    @ViewBuilder
    func AnimatedRing(_ status: Bool) -> some View {
        if status {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1.5)
                .matchedGeometryEffect(id: "RING", in: animation)
        }
    }
}

struct CustomTextField: View {
    var title: String
    var hint: String
    @Binding var value: String
    var onChange: () -> ()
    @FocusState private var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.gray)
            
            TextField(hint, text: $value)
                .padding(.horizontal, 15)
                .padding(.vertical, 12)
                .contentShape(.rect)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isActive ? .blue : .gray.opacity(0.5), lineWidth: 1.5)
                        .animation(.snappy, value: isActive)
                }
                .focused($isActive)
                .onChange(of: value) { oldValue, newValue in
                    onChange()
                }
        }
    }
}

extension String {
    func group(_ character: Character, count: Int) -> String {
        var modifiedString = self.replacingOccurrences(of: String(character), with: "")
        
        for index in 0..<modifiedString.count {
            if index % count == 0 && index != 0 {
                let groupCharactersCount = modifiedString.count(where: { $0 == character})
                let stringIndex = modifiedString.index(modifiedString.startIndex, offsetBy: groupCharactersCount + index)
                modifiedString.insert(character, at: stringIndex)
            }
        }
        return modifiedString
    }
    
    func dummyText(_ character: Character, count: Int) -> String {
        var tempText = String(self.prefix(count)).replacingOccurrences(of: String(character), with: "")
        let remaining = max(min(count - tempText.count, count), 0)
        if remaining > 0 {
            tempText.append(String(repeating: character, count: remaining))
        }
        return tempText
    }
}

#Preview {
    ContentView()
}
