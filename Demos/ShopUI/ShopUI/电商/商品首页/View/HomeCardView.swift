//
//  HomeCardView.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/7.
//

import SwiftUI

@available(iOS 15.0, *)
struct HomeCardView: View {
    
    @Binding var product: Product
    
    @Namespace var animation
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            Button {
                
                product.isLiked.toggle()
                
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
}

