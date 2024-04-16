//
//  DetailViewDetailView.swift
//  ShoeUI0903
//
//  Created by Lurich on 2021/9/7.
//

import SwiftUI

@available(iOS 15.0, *)
struct DetailViewDetailView: View {
    
    @EnvironmentObject var baseData: baseViewModel
    
    //for hero effect...
    var animation: Namespace.ID
    @Namespace var animationButton
    
    @State var size = "US 6"
    @State var shoeColor: Color = .red
    
    var body: some View {
        
        //safe check...
        if let product = baseData.currentProduct, baseData.showDetail {
            
            VStack(spacing: 0) {
                
                //top bar
                HStack {
                    
                    Button {
                        
                        withAnimation{
                            baseData.showDetail = false
                        }
                    } label: {
                        
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            
                    }

                   
                    Spacer()
                    
                    Button {
                        
                    } label: {
                                           
                        Image(systemName: "suit.heart.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red, in: Circle())
                            
                    }
                }
                .foregroundColor(.black)
                .overlay(
                    Image(systemName: "applelogo")
                        .font(.title)
                )
                .padding(.horizontal)
                .padding(.bottom)
                
                //show image...
                Image(product.productImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                //add mathched geometry befor frame()...
                    .matchedGeometryEffect(id: product.productImage, in: animation)
                    .frame(width: 250, height: 250)
                    .rotationEffect(.init(degrees: -20))
                    .background(
                        
                        ZStack {
                        
                            Circle()
                            .fill(product.productBG)
                            .padding()
                        
                            Circle()
                            .fill(.white.opacity(0.5))
                            .padding(40)
                        }
                    )
                    .frame(height: UIScreen.main.bounds.height / 3)
                
                //product Details...
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack {
                        
                        Text(product.productTitle)
                            .font(.title.bold())
                            
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("(\(product.productRating))")
                            .foregroundColor(.gray)
                    }
                    
                    Text("拥有财富、名声、权力，这世界上的一切的男人 “海贼王”哥尔·D·罗杰，在被行刑受死之前说了一句话，让全世界的人都涌向了大海。“想要我的宝藏吗？如果想要的话，那就到海上去找吧，我全部都放在那里。”，世界开始迎接“大海贼时代”的来临。")
                        .font(.callout)
                        .lineSpacing(10)
                    
                    //size
                    HStack(spacing: 0) {
                        
                        Text("Size: ")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                            .padding(.trailing)
                        
                        ForEach(["US 6", "US 7", "US 8", "US 9"], id: \.self) { size in
                            
                            Button {
                                self.size = size
                            } label: {
                                Text(size)
                                    .font(.callout)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(
                                        ZStack {
                                            if self.size == size {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.blue)
                                                    .matchedGeometryEffect(id: "US_BUTTON", in: animationButton)
                                                    .opacity(0.3)
                                            }
                                        }
                                    )
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    //Color
                    HStack(spacing: 15) {
                        
                        let colors : [Color] = [.yellow, .red, .purple, .pink]
                        
                        Text("Acailable Color: ")
                            .font(.caption.bold())
                            .foregroundColor(.gray)
                        
                        ForEach(colors, id: \.self) { color in
                            
                            Button {
                                self.shoeColor = color
                            } label: {
                                
                                Circle()
                                    .fill(color.opacity(0.5))
                                    .frame(width: 25, height: 25)
                                    .background(
                                        
                                        Circle()
                                            .stroke(Color("Pink"), lineWidth: 1.5)
                                            .opacity(shoeColor == color ? 0.2 : 0)
                                            .padding(-4)
                                    )
                                
                            }

                        }
                    }
                    .padding(.vertical)
                    
                    //add to cart...
                    Button {
                        
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            Image(systemName: "cart")
                                .font(.title)
                                
                            Text("Add To Cart")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color("Pink"))
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color("Pink").opacity(0.06))
                        .clipShape(Capsule())
                    }

                }
                .padding(.top)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    Color("Pink")
                        .opacity(0.05)
                        .cornerRadius(20)
                        .ignoresSafeArea(.container, edges: .bottom)
                )
                
            }
            .padding(.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .transition(.opacity)
        }
    }
}

@available(iOS 15.0, *)
struct DetailViewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ShopBaseView()
    }
}
