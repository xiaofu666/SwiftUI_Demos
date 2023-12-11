//
//  Home.swift
//  MatchedCarousel
//
//  Created by Lurich on 2021/6/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct MatchedCarouselView: View {
    
    @State var currentTab = "user1"
    
   
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { proxy in
                
                let size = proxy.size
                
                Image(currentTab)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(1)
                
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            .colorScheme(.dark)
            
            
            TabView(selection: $currentTab) {
                
                ForEach(1...6, id: \.self) { index in
                    
                    CarouseBodyView(index: index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
           
        }
    }
}

@available(iOS 15.0, *)
struct MatchedCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedCarouselView()
    }
}
