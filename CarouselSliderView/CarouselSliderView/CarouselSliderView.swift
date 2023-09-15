//
//  CarouselSliderView.swift
//  CarouselSlider
//
//  Created by Lurich on 2022/3/31.
//

import SwiftUI

@available(iOS 15.0, *)
struct CarouselSliderView: View {
    @State private var currentIndex: Int = 0
    
    @State private var posts: [Post] = example_posts
    @State private var currentTab = "Slide Show"
    @Namespace private var animation
    
    var body: some View {
        
        VStack (spacing: 15){
            
            // segment Control
            HStack(spacing: 0) {
                
                TabButton(title: "Slide Show", animation: animation, currentTab: $currentTab)
                TabButton(title: "List", animation: animation, currentTab: $currentTab)
                TabButton(title: "Imag", animation: animation, currentTab: $currentTab)
            }
            .background(Color.black.opacity(0.4), in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            //snap Carousel...
            SnapCarousel(index: $currentIndex, items: posts) { post in
                
                GeometryReader { proxy in
                    
                    let size = proxy.size
                    
                    Image(post.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .cornerRadius(12)
                }
                
            }
            .padding(.vertical, 80)
            
            //indicator...
            HStack(spacing: 10) {

                ForEach(posts.indices, id: \.self) { index in

                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding(.bottom, 40)
            
            
        }
        .navigationTitle("My Wishes")
        .frame(maxHeight:.infinity, alignment: .top)
    }
}

@available(iOS 15.0, *)
struct CarouselSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSliderView()
    }
}
