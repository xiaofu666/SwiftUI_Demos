//
//  CarouseBodyView.swift
//  MatchedCarousel
//
//  Created by Lurich on 2021/6/23.
//

import SwiftUI

struct CarouseBodyView: View {
    
    var index: Int
    
    @State var offset:CGFloat = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let size = proxy.size
            
            ZStack {
                
                Image("user\(index)")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(width: size.width - 8, height: size.height / 1.2, alignment: .center)
                    .cornerRadius(12)
                
                
                VStack(spacing: 25) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Human Intergration Supervisor")
                            .font(.title2.bold())
                            .kerning(1.5)
                            
                        
                        Text("The world's largest collection colllection of animation facts, pictures and more!")
                            .foregroundStyle(.primary)
                    }
                    .foregroundStyle(.white)
                    .padding(.top)
                    
                    Spacer()
                    
                    VStack (alignment:.leading){
                        HStack( spacing: 25) {
                            
                            Image("user\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("justine")
                                    .font(.title2.bold())
                                
                                Text("Apple Sheep")
                                    .foregroundStyle(.secondary)
                            }
                            .foregroundStyle(.black)
                        }
                        
                        HStack {
                            
                            VStack {
                                
                                Text("1303")
                                    .font(.title2.bold())
                                
                                Text("Posts")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            VStack {
                                
                                Text("2013")
                                    .font(.title2.bold())
                                
                                Text("Followers")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            VStack {
                                
                                Text("777")
                                    .font(.title2.bold())
                                
                                Text("Followeing")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top)
                    }
                    .padding(20)
                    .padding(.horizontal)
                    .background(.white)
                    .cornerRadius(12)
                }
                .padding(20)
            }
            .frame(width: size.width - 8, height: size.height / 1.2)
            .frame(width: size.width, height: size.height)
        }
        .tag("user\(index)")
        .rotation3DEffect(.init(degrees: getProgress() * 90), axis:(x:0, y: 1, z: 0), anchor: offset > 0 ?.leading : .trailing, anchorZ: 0, perspective: 0.5)
        //custom 3D rotation
        .modifier(ScrollViewOffsetModifier(anchorPoint: .leading, offset: $offset))
        
        
    }
    
    func getProgress()->CGFloat {
        
        let progress = -offset / UIScreen.main.bounds.width
        
        return progress
    }
}

struct CarouseBodyView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
