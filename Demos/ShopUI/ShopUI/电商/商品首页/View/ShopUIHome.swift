//
//  Home.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/3.
//

import SwiftUI

@available(iOS 15.0, *)
struct ShopUIHome: View {
    
    //Matched geometry Effect
    @Namespace var animation
    @EnvironmentObject var baseData: baseViewModel
    
    @State var products: [Product] = ProductsData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 15) {
                
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }

                   
                    Spacer()
                    
                    Button {
                        
                    } label: {
                                           
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
                .foregroundColor(.black)
                .overlay(
                    Image(systemName: "applelogo")
                        .font(.title)
                )
                
                
                HStack {
                    
                    Text("Our Products")
                        .font(.title.bold())
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        
                        HStack(spacing: 3) {
                            
                            Text("Sort by")
                                .font(.caption.bold())
                            
                            Image(systemName: "chevron.down")
                                .font(.caption.bold())
                        }
                        .foregroundColor(.gray)
                    }

                }
                .padding(.top, 25)
                
                //custom segment tab...
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 18) {
                        
                        //segmentButton
                        SegmentButton(image: "photo", title: "Sneakers")
                        SegmentButton(image: "applewatch", title: "Watch")
                        SegmentButton(image: "car", title: "car")
                    }
                    .padding(.vertical)
                }
               
                
                //product View
                let colunms = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
                
                //Grid view
                LazyVGrid(columns: colunms, spacing: 18) {
                    
                    // Products...
                    ForEach(products) { product in
                        
                        CardView(product: product)
                            .onTapGesture {
                                
                                withAnimation {
                                    
                                    baseData.currentProduct = product
                                    baseData.showDetail = true
                                }
                            }
                    }
                }
                
            }
            .padding()
            //bottom tab bar approx padding
            .padding(.bottom, 100)
        }
        .overlay(
            
            DetailViewDetailView(animation: animation).environmentObject(baseData)
        )
        
    }
    
    @ViewBuilder
    func CardView(product: Product) -> some View {
        
        VStack(spacing: 15) {
            
            Button {
                
//                product.isLiked.toggle()
                
            } label: {
                
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 13))
                    .foregroundColor(product.isLiked ? .white : .gray)
                    .padding(5)
                    .background(
                        
                        Color.red.opacity(product.isLiked ? 1 : 0),
                        in: Circle()
                    )
            }
            .frame(maxWidth: .infinity,  alignment: .trailing)

            Image(product.productImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: product.productImage, in: animation)
                .padding()
                .rotationEffect(.init(degrees: -20))
                .background(
                
                    ZStack {
                    
                        Circle()
                        .fill(product.productBG)
                        .padding(-10)
                    //white inner circle
                        Circle()
                        .stroke(Color.white, lineWidth: 1.4)
                        .padding(-3)
                        
                    }
                )
            
            Text(product.productTitle)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text(product.productPrice)
                .font(.title2.bold())
            
            HStack(spacing: 4) {
                
                ForEach(1...5, id: \.self) { index in
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 9.5))
                        .foregroundColor(product.productRating >= index ? .yellow : .gray.opacity(0.6))
                }
                
                Text("(\(product.productRating).0)")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
            }
        
        }
        .padding()
        .background(
            
            Color.white,
            in: RoundedRectangle(cornerRadius: 12)
            
        )
    }
    
    
    @ViewBuilder
    func SegmentButton(image:String, title: String) -> some View {
        
        Button {
            
            withAnimation{baseData.homeTab = title}
        } label: {
            
            HStack(spacing: 8) {
                
                Image(systemName: image)
                    .font(.title2)
                
                Text(title)
                    .font(.system(size: 12.5))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
            
                ZStack {
                    
                    if baseData.homeTab == title {
                    
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    }
                }
            )
        }

        
    }
    
}

@available(iOS 15.0, *)
struct ShopUIHome_Previews: PreviewProvider {
    static var previews: some View {
        
        ShopBaseView()
    }
}
