//
//  CardCreationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/5.
//

import SwiftUI

@available(iOS 16.0, *)
struct CardCreationView: View {
    @FocusState private var activeTF: ActiveKeyboardField!
    @State private var cardNumber: String = ""
    @State private var cardHolderName: String = ""
    @State private var cvvCode: String = ""
    @State private var expireDate: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Text("Add Card")
                    .font(.title3)
                    .padding(.leading, 10)
                
                Spacer(minLength: 0)
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            CardView()
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Label("Add Card", systemImage: "lock")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.blue.gradient)
                    }
                    .disableWithOpacity(cardNumber.count != 19 || cardHolderName.isEmpty || expireDate.count != 5 || cvvCode.count != 3)
            }
        }
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if activeTF != .cardHolderName {
                    Button("Next") {
                        switch activeTF {
                        case .cardNumber:
                            activeTF = .expirationDate
                        case .expirationDate:
                            activeTF = .cvv
                        case .cvv:
                            activeTF = .cardHolderName
                        case .cardHolderName:
                            break
                        case .none:
                            break
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func CardView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.linearGradient(colors: [Color.blue.opacity(0.5), Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(spacing: 10) {
                HStack {
                    TextField("XXXX XXXX XXXX XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""

                        let startIndex = value.startIndex
                        for index in 0..<value.count {
                            let valueIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[valueIndex])

                            if (index + 1) % 5 == 0 && value[valueIndex] != " " {
                                cardNumber.insert(" ", at: valueIndex)
                            }
                        }
                        
                        if cardNumber.last == " " {
                            cardNumber.removeLast()
                        }
                        
                        cardNumber = String(cardNumber.prefix(19))
                    }))
                        .font(.title3)
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cardNumber)
                    
                    Spacer(minLength: 0)
                    
                    Text("VISA")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .italic()
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 12) {
                    TextField("MM/YY", text: .init(get: {
                        expireDate
                    }, set: { value in
                        expireDate = value
                        
                        if value.count == 3 && value.last != "/" {
                            expireDate.insert("/", at: value.index(value.startIndex, offsetBy: 2))
                        }
                        
                        if expireDate.last == "/" {
                            expireDate.removeLast()
                        }
                        
                        expireDate = String(expireDate.prefix(5))
                    }))
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: .init(get: {
                        cvvCode
                    }, set: { value in
                        cvvCode = value
                        cvvCode = String(cvvCode.prefix(3))
                    }))
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cvv)
                        .frame(width: 35)
                    
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.white)
                }
                
                Spacer(minLength: 0)
                
                TextField("Card Holder Name", text: $cardHolderName)
                    .focused($activeTF, equals: .cardHolderName)
                    .submitLabel(.done)
            }
            .foregroundColor(.white)
            .padding(20)
            .tint(.white)

        }
        .frame(height: 200)
        .padding(.top, 20)
    }
}

@available(iOS 16.0, *)
struct CardCreationView_Previews: PreviewProvider {
    static var previews: some View {
        CardCreationView()
    }
}

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1.0)
    }
}
