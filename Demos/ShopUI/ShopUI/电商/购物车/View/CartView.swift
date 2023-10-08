//
//  CartView.swift
//  Cart
//
//  Created by Lurich on 2021/1/22.
//

import SwiftUI

struct CartView: View {
    
    @StateObject var cartData = CartViewModel()
    
    @Binding var isPresent: Bool
    
    var body: some View {
        
        VStack {
            
            HStack(spacing: 20) {
                
                Button(action: {
                    isPresent = false
                }, label: {
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight:.heavy))
                        .foregroundColor(.black)
                    
                    
                    Text("My cart")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                })
                
                Spacer()
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                LazyVStack(spacing: 0) {
                    
                    ForEach(cartData.items) { item in
                        ItemView(item: $cartData.items[getIndex(item: item)], items: $cartData.items)
                    }
                    
                }
                
            })
            
            
            VStack {
                
                HStack {
                    Text("Total")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(calculateTotaolPrice())
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                }
                .padding([.top, .horizontal])
                
                Button(action: {}, label: {
                    Text("Check out")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("lightBlue"), Color.blue]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(15)
                })
                
            }
            .background(Color.white)
            
            
            
        }
        .background(Color("White").ignoresSafeArea(.all))
        
    }
    
    func getIndex(item: Item) -> Int {
        
        return cartData.items.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        
    }
    
    func calculateTotaolPrice() -> String {
        
        var price : Float = 0
        
        cartData.items.forEach { (item) in
            price += item.price * Float(item.quantity)
        }
        
        return getPrice(value: price)
        
    }
    
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(isPresent: .constant(true))
    }
}
