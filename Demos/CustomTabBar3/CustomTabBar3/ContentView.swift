//
//  ContentView.swift
//  CustomTabBar3
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    
    @State var index : Int = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        
        VStack {
            
            ZStack {
                Text("Home")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BG").ignoresSafeArea())
                    .opacity(self.index == 0 ? 1 : 0)
                
                Text("Find")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BG").ignoresSafeArea())
                    .opacity(self.index == 1 ? 1 : 0)
                
                Text("Message")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BG").ignoresSafeArea())
                    .opacity(self.index == 2 ? 1 : 0)
                
                Text("Account")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BG").ignoresSafeArea())
                    .opacity(self.index == 3 ? 1 : 0)
                
                Text("Add")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("BG").ignoresSafeArea())
                    .opacity(self.index == 4 ? 1 : 0)
            }
            .padding(.bottom, -35)
            
            CustomTabBar3View(index: self.$index)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
    }
}


struct CustomTabBar3View : View {
    
    @Binding var index : Int
    
    var body: some View {
        
        HStack {
            
            Button(action: { self.index = 0 }, label: {
                
                Image(systemName: "house")
            })
            .font(.title3)
            .foregroundColor(Color.black.opacity(index == 0 ? 1 : 0.3))
            
            Spacer()
            
            Button(action: { self.index = 1 }, label: {
                
                Image(systemName: "magnifyingglass.circle")
            })
            .font(.title3)
            .foregroundColor(Color.black.opacity(index == 1 ? 1 : 0.3))
            .offset(x: 10)
           
            
            Spacer()
            
            Button(action: { self.index = 4 }, label: {
                
                Image(systemName: "plus")
                    .padding()
                    .background(Color.red)
                    .clipShape(Circle())
            })
            .font(.title3)
            .foregroundColor(Color.white)
            .offset(y : -25)
            
            Spacer()
            
            Button(action: { self.index = 2 }, label: {
                
                Image(systemName: "suit.heart")
            })
            .font(.title3)
            .foregroundColor(Color.black.opacity(index == 2 ? 1 : 0.3))
            .offset(x: -10)
            
            Spacer()
            
            Button(action: { self.index = 3 }, label: {
                
                Image(systemName: "person.circle")
            })
            .font(.title3)
            .foregroundColor(Color.black.opacity(index == 3 ? 1 : 0.3))
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 35)
        .padding(.top, 35)
        .background(Color.white)
        .clipShape(CustomTabBar3Shap())
    }
}


struct CustomTabBar3Shap : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path {path  in
            
            path.move(to: CGPoint(x: 0, y: 35))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 35))
            
            path.addArc(center: CGPoint(x: rect.width / 2 + 2, y: 35), radius: 35, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
        }
    }
}


#Preview {
    ContentView()
}
