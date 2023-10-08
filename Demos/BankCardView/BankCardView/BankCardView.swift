//
//  BankCardView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/15.
//

import SwiftUI

@available(iOS 16.0, *)
struct BankCardView: View {
    @State private var activePage: Int = 1
    @State private var myCards: [BankCardModel] = sampleCards
    @State private var offset: CGFloat = 0
    @State private var isManualAnimation: Bool = false
        
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    SubVstack(size, safeArea)
                }
                .onChange(of: offset) { newValue in
                    if newValue == 0 && activePage == 0 {
                        proxy.scrollTo("CONTENT", anchor: .topLeading)
                    }
                }
                .scrollDisabled(activePage == 0)
                .overlay {
                    if reverseProgress(size) < 0.15 && activePage == 0 {
                        ExpandedView {
                            isManualAnimation = true
                            withAnimation(.easeInOut(duration: 0.25)) {
                                activePage = 1
                                offset = -size.width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                                isManualAnimation = false
                            }
                        }
                        .scaleEffect(1.0 - reverseProgress(size))
                        .opacity(1.0 - reverseProgress(size) / 0.15)
                        .transition(.identity)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func SubVstack(_ size: CGSize, _ safeArea: EdgeInsets) -> some View {
        VStack(spacing: 10) {
            ProfileCard()
            
            Capsule()
                .fill(.gray.opacity(0.2))
                .frame(width: 50, height: 5)
                .padding(.vertical, 5)
            
            let pageHeight = size.height * 0.65
            GeometryReader {
                let rect = $0.frame(in: .global)
                
                TabView(selection: $activePage) {
                    ForEach(myCards) { card in
                        ZStack {
                            if card.isFirstBlankCard {
                                Rectangle()
                                    .fill(.clear)
                            } else {
                                BankCard(card: card)
                            }
                        }
                        .frame(width: rect.width - 60)
                        .tag(indexOf(card))
                        .getGlobalRect(activePage == indexOf(card)) { rect in
                            if !isManualAnimation {
                                let minx = rect.minX
                                let pageOffset = minx - (size.width * CGFloat(indexOf(card)))
                                offset = pageOffset
                            }
                        }
                    }
                }
                .tabViewStyle (.page(indexDisplayMode: .never))
                .background {
                    RoundedRectangle(cornerRadius: 40 * reverseProgress(size), style: .continuous)
                        .fill(Color("MyBlue"))
                        .frame(height: max(0, pageHeight + fullHeight(size, pageHeight, safeArea)))
                        .frame(width: max(0, rect.width - (60 * reverseProgress(size))), height: pageHeight, alignment: .top)
                        .offset(x: -15 * reverseProgress(size))
                        .scaleEffect(0.95 + (0.05 * progress(size)), anchor: .leading)
                        .offset(x: (offset + size.width) < 0 ? (offset + size.width) : 0)
                        .offset(y: (offset + size.width) > 0 ? (-rect.minY * progress(size)) : 0)
                }
            }
            .frame(height: pageHeight)
            .zIndex(1000)
            
            ExpensesView(expenses: myCards[activePage == 0 ? 1 : activePage].expenses)
                .padding(.horizontal, 30)
                .padding(.top, 10)
        }
        .padding(.top, safeArea.top + 15)
        .padding(.bottom, safeArea.bottom + 15)
        .id("CONTENT")
    }
    
    @ViewBuilder
    func ProfileCard() -> some View {
        HStack(spacing: 4) {
            Text("My")
                .font(.title)
            
            Text("Home")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer(minLength: 0)
            
            Image("Pic")
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(height: 55)
                .clipShape(Circle())
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 35)
        .background {
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .fill(.purple.opacity(0.3))
        }
        .padding(.horizontal, 30)
    }
    
    
    @ViewBuilder
    func ExpandedView(dismiss: @escaping () -> ()) -> some View {
        VStack {
            VStack(spacing: 30) {
                HStack(spacing: 12) {
                    Image(systemName: "creditcard.fill")
                        .font(.title2)
                    
                    Text("Credit Card")
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .trailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title.bold())
                            .foregroundColor(.white.opacity(0.5))
                    }

                }
                
                HStack(spacing: 12) {
                    Image(systemName: "building.columns.fill")
                        .font(.title2)
                    
                    Text("Credit Card")
                        .font(.title3.bold())
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                    
                    Image(systemName: "eurosign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.leading, -25)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("MyPurpleBG"))
            }
            
            Text("Your Card Number")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.35))
                .padding(.top, 10)
            
            let values: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "scan", "0", "back"]
            
            GeometryReader { proxy in
                let size = proxy.size
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)) {
                    ForEach(values, id: \.self) { item in
                        Button {
                            
                        } label: {
                            if item == "scan" {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.title.bold())
                            } else if item == "back" {
                                Image(systemName: "delete.backward")
                                    .font(.title.bold())
                            } else {
                                Text(item)
                                    .font(.title.bold())
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: size.width / 3, height: size.height / 4)
                        .contentShape(Rectangle())

                    }
                }
                .padding(.horizontal, -15)
            }
            
            Button {
                
            } label: {
                Text("Add Card")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("MyPurpleBG"))
                    }
            }

        }
        .padding(.horizontal, 15)
        .padding(.top, 15 + getSafeArea().top)
        .padding(.bottom, 15 + getSafeArea().bottom)
    }
    
    private func indexOf(_ page: BankCardModel) -> Int {
        return myCards.firstIndex(of: page) ?? 0
    }
    
    func fullHeight(_ size: CGSize, _ pageHeight: CGFloat, _ safeArea: EdgeInsets) -> CGFloat {
        let progress = progress(size)
        let screenHeight = progress * (size.height - pageHeight + safeArea.top + safeArea.bottom)
        return screenHeight
    }
    
    func progress(_ size: CGSize) -> CGFloat {
        let pageOffset = offset + size.width
        let progress = pageOffset / size.width
        return min(progress, 1)
    }
    
    func reverseProgress(_ size: CGSize) -> CGFloat {
        return max(1 - progress(size), 0)
    }
}

@available(iOS 16.0, *)
struct BankCardView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardView()
    }
}

@available(iOS 16.0, *)
struct BankCard: View {
    var card: BankCardModel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(card.cardColor.gradient)
                    .overlay(alignment: .top) {
                        VStack {
                            HStack {
                                Image(systemName: "simcard")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.yellow)
                                    .rotationEffect(.degrees(90))
                                    .frame(width: 65, height: 65)
                                
                                Spacer()
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Spacer()
                            
                            Text(card.cardBalance)
                                .font(.largeTitle.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(30)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3)
                    .overlay {
                        VStack {
                            Text(card.cardName)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            HStack {
                                Text("Debit Card")
                                    .font(.callout)
                                
                                Spacer()
                                
                                Text("VISA")
                                    .font(.largeTitle.bold().italic())
                            }
                        }
                        .foregroundColor(.white)
                        .padding(30)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
        }
    }
}

struct ExpensesView: View {
    var expenses: [ExpenseModel]
    @State private var animationChange: Bool = true
    
    var body: some View {
        VStack(spacing: 18) {
            ForEach(expenses) { expense in
                HStack(spacing: 12) {
                    Image(expense.productIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(expense.product)
                        Text(expense.spendType)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(expense.amountSpent)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
        }
        .opacity(animationChange ? 1 : 0)
        .offset(y: animationChange ? 0 : 50)
        .onChange(of: expenses) { newValue in
            withAnimation(.easeInOut(duration: 0.1)) {
                animationChange = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    animationChange = true
                }
            }
        }
    }
}
extension View {
    @ViewBuilder
    func getGlobalRect(_ addObserver: Bool = false, completion:@escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
            if addObserver {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    Color.clear
                        .preference(key: RectKey.self, value: rect)
                        .onPreferenceChange(RectKey.self, perform: completion)
                }
            }
        }
    }
}
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
