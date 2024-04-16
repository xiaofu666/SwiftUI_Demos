//
//  CardGroupAnimationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/5/7.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct CardGroupAnimationView: View {
    var body: some View {
        GeometryReader { proxy in
            CardGroupAnimationDetailView(size: proxy.size)
        }
    }
}

@available(iOS 16.0, *)
struct CardGroupAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CardGroupAnimationView()
    }
}

@available(iOS 16.0, *)
struct CardGroupAnimationDetailView: View {
    var size: CGSize
    let cardModel: CardGroupModel = CardGroupModel()
    let cards: [BankCardModel] = {
        sampleCards.filter{
            $0.isFirstBlankCard == false
        }
    }()
    @State private var expandCards: Bool = false
    @State private var showDetailView: Bool = false
    @State private var showDetailContent: Bool = false
    @State private var selectedCard: BankCardModel?
    @Namespace private var animation
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Your Balance")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("$1234.56")
                        .font(.title2.bold())
                }
            }
            .padding(15)
            
            CardsView()
                .padding(.horizontal, 15)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    BottomScrollContent()
                }
                .padding(.top, 30)
                .padding([.horizontal, .bottom], 15)
            }
            .frame(maxWidth: .infinity)
            .background {
                ClipCornerShape(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.white)
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
            .padding(.top, 20)
        }
        .background {
            Rectangle()
                .fill(.black.opacity(0.05))
                .ignoresSafeArea()
        }
        .overlay(content: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
                .overlay(alignment: .top, content: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    expandCards = false
                                }
                            }
                        
                        Spacer()
                        
                        Text("All Cards")
                            .font(.title2.bold())
                    }
                    .padding(15)
                })
                .opacity((expandCards && !showDetailContent) ? 1 : 0)
        })
        .overlay(content: {
            if let card = selectedCard, showDetailView {
                CardDetailView(card)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        })
        .overlayPreferenceValue(CardRectKey.self) { preference in
            if let cardPreference = preference["CardRect"] {
                GeometryReader { proxy in
                    let cardRect = proxy[cardPreference]
                    CardContent()
                        .frame(width: cardRect.width, height: expandCards ? nil : cardRect.height)
                        .offset(x: cardRect.minX, y: cardRect.minY)
                }
                .allowsHitTesting(!showDetailView)
            }
        }
    }
    
    @ViewBuilder
    func CardDetailView(_ card: BankCardModel) -> some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.bold)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showDetailContent = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showDetailView = false
                            }
                        }
                    }
                
                Spacer()
                
                Text("Transactions")
                    .font(.title2.bold())
            }
            .foregroundColor(.black)
            .padding(15)
            .opacity(showDetailContent ? 1 : 0)
            
            CardView(card)
                .rotation3DEffect(.init(degrees: showDetailContent ? 0 : -15), axis: (x: 1, y: 0, z: 0), anchor: .top)
                .matchedGeometryEffect(id: card.id, in: animation)
                .frame(height: 200)
                .padding([.horizontal, .top], 15)
                .padding(.bottom, 10)
                .zIndex(100)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(cardModel.expenses) { expense in
                        HStack(spacing: 12) {
                            Image(expense.productIcon)
                                .resizable()
                                .aspectRatio(nil, contentMode: .fill)
                                .background(.gray)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.product)
                                    .font(.title3.bold())
                                
                                Text(expense.spendType)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(expense.amountSpent)
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                    }
                }
                .padding(.top, 25)
                .padding([.horizontal, .bottom], 15)
            }
            .background {
                ClipCornerShape(corners: [.topLeft, .topRight], radius: 30)
                    .fill(.white)
                    .padding(.top, -225)
                    .ignoresSafeArea()
            }
            .offset(y: !showDetailContent ? size.height * 0.7 : 0)
            .opacity(showDetailContent ? 1 : 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(Color("BG"))
                .ignoresSafeArea()
                .opacity(showDetailContent ? 1 : 0)
        }
    }
    
    @ViewBuilder
    func CardContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(cards.reversed()) { card in
                    let index = CGFloat(indexOf(card))
                    let reversedIndex = CGFloat(sampleCards.count - 2) - index
                    let displayingStackIndex = min(index, 2)
                    let displayScale = (displayingStackIndex / CGFloat(cards.count)) * 0.15
                    
                    ZStack {
                        if selectedCard?.id == card.id && showDetailView {
                            Rectangle()
                                .fill(.clear)
                        } else {
                            CardView(card)
                                .rotation3DEffect(.init(degrees: expandCards ? (showDetailView ? (-15) : 0) : 0), axis: (x: 1, y: 0, z: 0), anchor: .top)
                                .matchedGeometryEffect(id: card.id, in: animation)
                                .offset(y: showDetailView ? size.height * 0.9 : 0)
                                .onTapGesture {
                                    if expandCards {
                                        selectedCard = card
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showDetailView = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                showDetailContent = true
                                            }
                                        }
                                    } else {
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            expandCards = true
                                        }
                                    }
                                }
                        }
                    }
                    .frame(height: 200)
                    .scaleEffect(1 - (expandCards ? 0 : displayScale))
                    .offset(y: expandCards ? 0 : (displayingStackIndex * -15))
                    .offset(y: reversedIndex * -200)
                    .padding(.top, expandCards ? (reversedIndex == 0 ? 0 : 80) : 0)
                }
            }
            .padding(.top, 45)
            .padding(.bottom, CGFloat(sampleCards.count - 2) * -200)
        }
        .scrollDisabled(!expandCards)
    }
    
    func indexOf(_ card: BankCardModel) -> Int {
        return cards.firstIndex {
            $0.id == card.id
        } ?? 0
    }
    
    @ViewBuilder
    func CardView(_ card: BankCardModel) -> some View {
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
                                    .frame(width: 55, height: 55)
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Text(card.cardBalance)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(20)
                        .foregroundColor(.black)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3.5)
                    .overlay {
                        HStack {
                            Text(card.cardName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text("VISA")
                                .font(.largeTitle.bold())
                                .fontWeight(.heavy)
                                .italic()
                        }
                        .foregroundColor(.white)
                        .padding(15)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 245)
            .anchorPreference(key:CardRectKey.self, value: .bounds) { anchor in
                return ["CardRect": anchor]
            }
    }
    
    @ViewBuilder
    func BottomScrollContent() -> some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Instant Transfer")
                    .font(.title3.bold())
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(1...7, id: \.self) { index in
                            Circle()
                                .fill([.black, .red, .orange, .yellow, .green, .cyan, .blue, .purple][index])
                                .frame(width: 55, height: 55)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                }
                .padding(.horizontal, -15)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Overview")
                        .font(.title3.bold())
                    
                    Spacer()
                    
                    Text("Last 4 Months")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Chart(cardModel.sampleData) { overview in
                    ForEach(overview.value) { data in
                        BarMark(x: .value("Month", data.month, unit: .month), y: .value(overview.type.rawValue, data.amount))
                    }
                    .foregroundStyle(by: .value("Type", overview.type.rawValue))
                    .position(by: .value("Type", overview.type.rawValue))
                }
                .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
                .frame(height: 200)
                .padding(.top, 25)
            }
            .padding(.top, 15)
        }
    }
}

class CardGroupModel {
    /// Card Model & Sample Cards

    struct Expense: Identifiable {
        var id: UUID = .init ()
        var amountSpent: String
        var product: String
        var productIcon: String
        var spendType: String
    }
    
    var expenses: [Expense] = [
        Expense(amountSpent: "$128", product: "Amazon",    productIcon: "user1",        spendType: "Groceries"),
        Expense(amountSpent: "$18",  product: "Youtube",   productIcon: "user2",        spendType: "Streaming"),
        Expense(amountSpent: "$10",  product: "Dribble",   productIcon: "user3",        spendType: "Membership"),
        Expense(amountSpent: "$28",  product: "Apple",     productIcon: "user4",        spendType: "Apple Pay"),
        Expense(amountSpent: "$9",   product: "mpatreon",  productIcon: "user5",        spendType: "Membership"),
        Expense(amountSpent: "$108", product: "Instagram", productIcon: "user6",        spendType: "Ad Publish"),
        Expense(amountSpent: "$55",  product: "Netflix",   productIcon: "Netflix",      spendType: "Movies"),
        Expense(amountSpent: "$348", product: "photoshop", productIcon: "Logo1",        spendType: "Editing"),
        Expense(amountSpent: "n$99", product: "Figma",     productIcon: "Logo2",        spendType: "Pro Member"),
    ]
    
    struct OverviewModel: Identifiable {
        var id: UUID = .init()
        var type: OverviewType
        var value: [OverviewValue]
        
        struct OverviewValue: Identifiable {
            var id: UUID = .init()
            var month: Date
            var amount: Double
        }
    }
    enum OverviewType: String {
        case income = "Income"
        case expense = "Expense"
    }
        
    var sampleData: [OverviewModel] = [
        .init(type: .income, value: [
            .init(month: .addMonth(-4),amount: 3550),
            .init(month: .addMonth(-3),amount: 2984.6),
            .init(month: .addMonth(-2),amount: 1989.67),
            .init(month: .addMonth(-1),amount: 2987.3)
        ]),
        .init(type: .expense, value: [
            .init(month: .addMonth(-4),amount: 2871.6),
            .init(month: .addMonth(-3),amount: 1628.0),
            .init(month: .addMonth(-2),amount: 786),
            .init(month: .addMonth(-1),amount: 1987.3)
        ])
    ]
}

extension Date {
    static func addMonth(_ value: Int) -> Self {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: value, to: .init()) ?? .init()
    }
}


//指定方向加圆角 [topLeft, topRight, bottomLeft, bottomRight] 或 allCorners
///example :  ClipCornerShape(corners: [.topRight, .bottomRight], radius: 10)
struct ClipCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CardRectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
