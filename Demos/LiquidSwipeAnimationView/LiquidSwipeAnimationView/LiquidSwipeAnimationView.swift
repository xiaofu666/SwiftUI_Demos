//
//  ContentView.swift
//  LiquidSwipeAnimationUI
//
//  Created by Lurich on 2021/6/27.
//

import SwiftUI

struct LiquidSwipeAnimationView: View {
    
    //Liquid swipe offset
    @State var offset: CGSize = .zero
    @State var showHome = false
    
    
    var body: some View {
        
        ZStack {
            Color.purple
                .overlay(
                    //conten ....
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("For Gamers")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                    })
                    .foregroundColor(.white)
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                    //For Draggesture to identify
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                        offset = value.translation
                                    }
                                })
                                .onEnded({ (value) in
                                    let screen = UIScreen.main.bounds
                                    withAnimation(.spring()) {
                                        //validating
                                        if -offset.width > screen.width / 2 {
                                            //removing view
                                            offset.width = -screen.height
                                            showHome.toggle()
                                        } else {
                                            offset = .zero
                                        }
                                        
                                    }
                                }))
                        .offset(x:15, y: 58 + 60/2)
                    //hiding while dragging starts...
                        .opacity(offset == .zero ? 1 : 0)
                    
                    ,alignment: .topTrailing
                )
            
                .padding(.trailing)
            
            if showHome {
                Text("Welcome To Home")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .onTapGesture {
                        // resetingview
                        withAnimation(.spring()) {
                            offset = .zero
                            showHome.toggle()
                        }
                    }
            }
            
        }
    }
}


struct LiquidSwipeAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LiquidSwipeAnimationView()
    }
}
