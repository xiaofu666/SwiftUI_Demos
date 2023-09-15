//
//  Home.swift
//  Parallax Carousel
//
//  Created by Lurich on 2021/1/31.
//

import SwiftUI

var screen = UIScreen.main.bounds

struct ParallaxCarouselView: View {
    
    @State var slected : Int = 0
    
    var width = screen.width
    var height = screen.height
    
    var body: some View {
        
        TabView(selection: $slected,
                content:  {
                    
                    ForEach(1...6, id: \.self) { index in
                        
                        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom), content: {
                            
                            GeometryReader { reader in
                                
                                Image("user\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    // moving view in opposite side
                                    // whe user starts to swipe...
                                    // this will create parallax Effect...
                                    .offset(x: -reader.frame(in: .global).minX)
                                    .frame(width: width, height: height / 2)
                                    
                            }
                            .frame(height: height / 2)
                            .cornerRadius(15)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: -5, y: -5)
                            // decreasing width by padding
                            // so outer view only decreased
                            // inner image will be full width
                            
                            Image("Pic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                                .padding(5)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x:-15, y: 25)
                            
                        })
                        .padding(.horizontal, 25)
                    }
                })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}


