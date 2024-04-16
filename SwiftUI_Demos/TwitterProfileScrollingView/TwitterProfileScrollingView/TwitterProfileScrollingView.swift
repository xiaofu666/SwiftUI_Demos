//
//  Home.swift
//  TwitterProfileScrolling
//
//  Created by Lurich on 2021/6/15.
//

import SwiftUI

struct TwitterProfileScrollingView: View {
    var size: CGSize
    @State var offset: CGFloat = 0
    
    //for dark mode adoption
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentTab = "Tweets"
    
    var sampleText = "Here I try making concepts more understandable.My goal is to make complex codes simple and extend unreached benefits of SwiftUI.For more information reach out to us."
    
    //for smooth slide Animation
    @Namespace var animation
    
    @State var tabBarOffset: CGFloat = 0
    
    @State var titleOffset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 15) {
                
                //header view ...
                GeometryReader { proxy -> AnyView in

                    let minY = proxy.frame(in: .global).minY

                    DispatchQueue.main.async {
                        
                        self.offset = minY
                    }
                    
                    return AnyView (

                        ZStack {

                            //banner ....
                            Image("Logo1")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: minY > 0 ? 180 + minY : 180, alignment: .center)
                                .cornerRadius(0)
                        
                            BlurEffect(style: .dark)
                                .opacity(blurViewOpacity())
                        
                            //title View
                            VStack {
                                
                                Text("Kavsoft")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("150 Tweets")
                                    .foregroundColor(.white)
                            }
                            .offset(y: 120)
                            .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                            .opacity(titleOffset < 100 ? 1 : 0)

                        }
                        .clipped()
                        //stretchy header ...
                        .frame(height:minY > 0 ? 180 + minY : nil)
                            .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
                    )
            
                }
                .frame(height: 180)
                .zIndex(1)
                
                
                // profile image...
                VStack {
                    
                    HStack {
                        
                        Image("Pic")
                            .resizable()
                            .aspectRatio( contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .padding(8)
                            .background(
                                colorScheme == .dark ? Color.black : Color.white
                            )
                            .clipShape(Circle())
                            .offset(y: offset < 0 ? getOffset() - 20 : -20)
                            .scaleEffect(getScale())
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            
                            Text("Edit Profile")
                                .foregroundColor(.blue)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(
                                    Capsule()
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }

                    }
                    .padding(.top, -25)
                    .padding(.bottom, -10)
                    
                    //profile data...
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Kavsoft2")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("@_kavsoft")
                            .foregroundColor(.gray)
                        
                        Text("Kavsoft is a channel where I focus on making tutorials on Swift and SwiftUI that makes working with it fun, simple and easy.")
                        
                        HStack( spacing: 5) {
                            
                            Text("13")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                            
                            Text("Followers")
                                .foregroundColor(.gray)
                            
                            Text("680")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .padding(.leading, 10)
                            
                            Text("Following")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                    }
                    .overlay(
                    
                        GeometryReader { proxy -> Color in
                            
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.titleOffset = minY
                            }
                        
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                        
                        ,alignment: .top
                    )
                    
                    //custom segmented menu....
                    VStack (spacing: 0){
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 30) {
                                
                                TabButton(title: "Tweets", animation: animation, currentTab: $currentTab, type: .line, titleColor: colorScheme == .dark ? .white : .black, bgColor: colorScheme == .light ? .white : .black)
                                
                                TabButton(title: "Tweets & Likes", animation: animation, currentTab: $currentTab, type: .line, titleColor: colorScheme == .dark ? .white : .black, bgColor: colorScheme == .light ? .white : .black)
                                
                                TabButton(title: "Media", animation: animation, currentTab: $currentTab, type: .line, titleColor: colorScheme == .dark ? .white : .black, bgColor: colorScheme == .light ? .white : .black)
                                
                                TabButton(title: "Likes", animation: animation, currentTab: $currentTab, type: .line, titleColor: colorScheme == .dark ? .white : .black, bgColor: colorScheme == .light ? .white : .black)
                                
                            }
                        }
                        
                        Divider()
                    }
                    .padding(.top, 30)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                    .overlay(
                        
                        GeometryReader { reader -> Color in
                        
                            let minY = reader.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.tabBarOffset = minY
                            }
                            
                        
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                        
                        ,alignment: .top
                    )
                    .zIndex(1)
                    
                    VStack(spacing: 18) {
                        
                        //sample tweets
                        TweetView(tweet: "Website : https://kavsoft.dev/\nInstagram : https://www.instagram.com/_kavsoft/", tweetImage: "Logo2")
                        
                        Divider()
                        
                        ForEach(1...20, id: \.self) { _ in
                            
                            TweetView(tweet: sampleText)
                            
                            Divider()
                        }
                    }
                    .padding(.top)
                    .zIndex(0)
                }
                .padding(.horizontal)
                // moving the view back if it goes > 80
                .zIndex(-offset > 80 ? 0 : 1)
            }
        }
        .ignoresSafeArea()
    }
    
    func getTitleTextOffset() -> CGFloat {
        
        let progress = 20 / titleOffset
        
        let offset = 60 * (progress > 0  && progress <= 1 ? progress : 1)
        
        return offset
    }
    
    
    // profile shrinking effect...
    func getOffset() -> CGFloat {
        
        let progress = (-offset / 80) * 20
        
        return progress < 20 ? progress : 20
    }
    
    func getScale() -> CGFloat {
        
        let progress = -offset / 80
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity() -> Double {
        
        let progress  = -(offset + 80) / 150
        
        return Double(-offset > 80 ? progress : 0)
        
    }
    
}

struct TwitterProfileScrollingView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

struct TweetView: View {
    
    var tweet: String
    var tweetImage: String?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            
            Image("Pic")
                .resizable()
                .aspectRatio( contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Kavsoft    ")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                +
                
                Text("@_kavsoft")
                    .foregroundColor(.gray)
                
                
                Text(tweet)
                    .frame(maxHeight:100, alignment: .top)
                
                if let image = tweetImage {
                    
                    GeometryReader { proxy in
                        
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.frame(in: .global).width, height: 250)
                            .cornerRadius(15)
                    }
                    .frame(height: 250)
                }
                
            }
        }
    }
}
