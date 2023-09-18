//
//  FoodDelivery.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

@available(iOS 15.0, *)
struct FoodDelivery: View {
    @State private var currentIndex = 0
    @State private var currentTab = tabModels[0]
    @Namespace var animation
    @State var selectedMilkShake: MilkShake?
    @State var showDetail = false
    var body: some View {
        VStack {
            HeaderView()
                .zIndex(1)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(attributedTitle)
                
                Text(attributedSubTitle)
            }
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .opacity(showDetail ? 0 : 1)
            
            GeometryReader { proxy in
                CarouselView(proxy.size)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(content: {
            if let selectedMilkShake, showDetail {
                FoodDetailView(animation: animation, milkShake: selectedMilkShake, show: $showDetail)
            }
        })
        .background {
            Color("LightGreen-0")
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func CarouselView(_ size: CGSize) -> some View {
        VStack(spacing: -40) {
            SnapCarousel(index: $currentIndex, items: milkShakes) { milkShake in
                VStack(spacing: 10) {
                    ZStack {
                        if showDetail && selectedMilkShake?.id == milkShake.id {
                            Image(milkShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(-2))
                                .opacity(0)
                        } else {
                            Image(milkShake.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(-2))
                                .matchedGeometryEffect(id: milkShake.id, in: animation)
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: size.height / 10)
                            .fill(Color("LightGreen-1"))
                            .padding(.top, 10)
                            .padding(.horizontal, -40)
                            .offset(y: -10)
                    }
                    
                    Text(milkShake.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Text(milkShake.price)
                        .font(.callout)
                        .fontWeight(.black)
                        .foregroundColor(Color("LightGreen-0"))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        selectedMilkShake = milkShake
                        showDetail = true
                    }
                }
                .padding(.top, 80)
                .padding(.horizontal, 40)
            }
            .frame(height: size.height * 0.8)
            
            Indicators()
                .padding(.bottom, 8)
        }
        .frame(width: size.width, height: size.height, alignment: .bottom)
        .padding(.bottom, 8)
        .opacity(showDetail ? 0 : 1)
        .background {
            CustomArcShape()
                .fill(.white)
                .scaleEffect(showDetail ? 2 : 1, anchor: .bottom)
                .overlay(alignment: .topLeading, content: {
                    TabMenu()
                })
                .padding(.top, 40)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func TabMenu() -> some View {
        HStack(spacing: 30) {
            ForEach(tabModels) { tabModel in
                Image(tabModel.tabImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 50)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(Color("LightGreen-1"))
                    }
                    .background(content: {
                        Circle()
                            .fill(.white)
                            .padding(-2)
                    })
                    .shadow(color: .black.opacity(0.07), radius: 5, x: 5, y: 5)
                    .offset(tabModel.tabOffset)
                    .scaleEffect(currentTab.id == tabModel.id ? 1.15 : 0.9, anchor: .bottom)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentTab = tabModel
                        }
                    }
            }
        }
        .opacity(showDetail ? 0 : 1)
        .padding(.leading, 15)
    }
    
    @ViewBuilder
    func Indicators() -> some View {
        HStack(spacing: 2) {
            ForEach(milkShakes.indices, id:\.self) { index in
                Circle()
                    .fill(Color("LightGreen-0"))
                    .frame(width: currentIndex == index ? 10 : 6, height: currentIndex == index ? 10 : 6)
                    .padding(4)
                    .background {
                        if currentIndex == index {
                            Circle()
                                .stroke(Color("LightGreen-0"), lineWidth: 1)
                                .matchedGeometryEffect(id: "INDRCITOR", in: animation)
                        }
                    }
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                //
            } label: {
                HStack(spacing: 10) {
                    Image("Pic")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Text("Lurich")
                        .font(.body)
                        .foregroundColor(.black)
                }
                .padding(.leading, 8)
                .padding(.trailing, 12)
                .padding(.vertical, 6)
                .background {
                    Capsule()
                        .fill(Color("LightGreen-1"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(showDetail ? 0 : 1)

            Button {
                //
            } label: {
                Image(systemName: "cart")
                    .font(.title2)
                    .foregroundColor(.black)
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 2, y: -5)
                        
                    }
            }

        }
        .padding(15)
    }
    
    var attributedTitle: AttributedString {
        var attributedString = AttributedString(stringLiteral: "Good Food,")
        if let range = attributedString.range(of: "Food,") {
            attributedString[range].foregroundColor = .white
        }
        return attributedString
    }
    
    var attributedSubTitle: AttributedString {
        var attributedString = AttributedString(stringLiteral: "Good Mood.")
        if let range = attributedString.range(of: "Good") {
            attributedString[range].foregroundColor = .white
        }
        return attributedString
    }
}

@available(iOS 15.0, *)
struct FoodDelivery_Previews: PreviewProvider {
    static var previews: some View {
        FoodDelivery()
    }
}

@available(iOS 15.0, *)
struct FoodDetailView: View {
    var animation: Namespace.ID
    var milkShake: MilkShake
    @Binding var show: Bool
    
    @State var orderType = "Active Order"
    @State var showContent = false
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation((.easeInOut(duration: 0.35))) {
                        showContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation((.easeInOut(duration: 0.35))) {
                            show = false
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .overlay {
                Text("Detail")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .padding(.top, 8)
            .opacity(showContent ? 1 : 0)
            
            HStack(spacing: 0) {
                ForEach(["Active Order","Past Order"], id: \.self) { order in
                    Text(order)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(orderType == order ? .black : .gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background {
                            if orderType == order {
                                Capsule()
                                    .fill(Color("LightGreen-1"))
                                    .matchedGeometryEffect(id: "ORDER", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                orderType = order
                            }
                        }
                }
            }
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
            .opacity(showContent ? 1 : 0)
            
            Image(milkShake.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(-2))
                .matchedGeometryEffect(id: milkShake.id, in: animation)
            
            GeometryReader { proxy in
                let size = proxy.size
                MilkShakeDetailsBottomView()
                    .offset(y: showContent ? 0 : size.height + 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 0.5)))
        .onAppear() {
            withAnimation(.easeInOut) {
                showContent = true
            }
        }
    }
    
    @ViewBuilder
    func MilkShakeDetailsBottomView() -> some View {
        VStack {
            VStack(spacing: 12) {
                Text("#512D Code")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(milkShake.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(milkShake.price)
                    .font(.callout)
                    .fontWeight(.black)
                    .foregroundColor(Color("LightGreen-0"))
                
                Text("20min delivery")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    Text("Quantity: ")
                        .font(.callout.bold())
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                    }
                    
                    Text("\(2)")
                        .font(.title3)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
                .foregroundColor(.gray)
                
                Button {
                    
                } label: {
                    Text("Add to cart")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .foregroundColor(.black)
                        .background {
                            Capsule()
                                .fill(Color("LightGreen-0"))
                        }
                }
                .padding(.top, 10)

            }
            .padding(.horizontal, 60)
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: 40, style: .continuous)
                    .fill(Color("LightGreen-1"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
