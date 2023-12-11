//
//  OnBoarding.swift
//  OnBoardingAnimation0901
//
//  Created by Lurich on 2021/9/1.
//

import SwiftUI

@available(iOS 15.0, *)
struct OnBoardingView: View {
    
    @State var index: Int = 0
    @State var offset: CGFloat = 0
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        OffsetPageTabView(selection: $index, offset: $offset) {
            HStack(spacing: 0) {
                ForEach(posts) {post in
                    VStack(spacing: 15) {
                        Image(post.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: getScreenRect().width - 100, height: getScreenRect().width - 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .clipped()
                            .offset(y: -120)
                        
                        VStack (alignment: .leading, spacing: 12) {
                            
                            Text(post.title)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            Text(post.description)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineLimit(4)
                        }
                        .frame(maxWidth:.infinity,  alignment:.leading)
                        .offset(y: -70)
                        
                        Spacer()
                    }
                    .padding(.top, 150)
                    .padding()
                    .frame(width:getScreenRect().width)
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .navigationBarHidden(true)
        // animation...
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(.white)
                .frame(width: getScreenRect().width - 100, height: getScreenRect().width - 100)
                .scaleEffect(2)
                .rotationEffect(.init(degrees: 25))
                .rotationEffect(.init(degrees: getRotation()))
                .offset(y: -getScreenRect().width + 20)
        )
        .background(
            Color("Card-\(getIndex() + 1)")
                .animation(.easeInOut, value: getIndex())
        )
        .ignoresSafeArea(.container, edges: .all)
        .overlay(
            VStack {
                HStack(spacing: 25){
                        
                        Button {
                            dismiss()
                        } label: {
                            
                            Text("Back")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                        }

                        Button {
                            
                        } label: {
                            
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .offset(x: -5)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                        }
                        
                }
            
                HStack{
                    
                    HStack {
                        Button {
//                            offset = max(offset - getScreenRect().width, 0)
                            index = max(index - 1, 0)
                        } label: {
                            
                            Text("Prev")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    
                    CapsuleIndicators(dataArr: posts, pageWidth: getScreenRect().width, offset: $offset)
                    
                    HStack {
                        
                        Spacer()
                        Button {
//                            offset = min(offset + getScreenRect().width, getScreenRect().width * Double(posts.count-1))
                            index = min(index + 1, posts.count-1)
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(.top, 30)
                .padding(.horizontal, 8)
            }
                .padding()
            
            ,alignment: .bottom
        )
    }
    
    //getting rotation...
    func getRotation() ->Double {
        let progress = offset / (getScreenRect().width * 4)
        let rotation = Double(progress) * 360
        
        return rotation
    }
    
    
    
    // changing bg color based on offset ...
    func getIndex() -> Int {
        let progress = (offset / getScreenRect().width).rounded()
        return  Int(progress)
    }
}

@available(iOS 15.0, *)
struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
