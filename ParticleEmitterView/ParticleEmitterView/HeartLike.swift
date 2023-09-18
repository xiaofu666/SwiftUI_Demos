//
//  HeartLike.swift
//  ParticleEmitterView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct HeartLike: View {
    
    // animation properites...
    @Binding var isTapped: Bool
    
    @State var startAnimation = false
    @State var bgAnimation = false
    
    //Reseting bg...
    @State var resetBG = false
    @State var fireworkAnimation = false
    
    @State var animationEnded = false
    
    //To avoid taps during animation
    @State var tapComplete = false
    
    //setting how many taps...
    var taps: Int = 1
    
    var body: some View {
        
        //heart like Animation
        Image(systemName: resetBG ? "suit.heart.fill" : "suit.heart")
            .font(.system(size: 45))
            .foregroundColor(resetBG ? .red : .gray)
        //scaling..
            .scaleEffect(startAnimation && !resetBG ? 0 : 1)
            .opacity(startAnimation && !animationEnded ? 1 : 0)
        //bg...
            .background(
                
                ZStack {
                
//                CustomShape(radius:  resetBG ? 29 : 0)
//                    .fill(Color.purple)
//                    .clipShape(Circle())
//                    //fixed size..
//                    .frame(width: 50, height: 50)
//                    .scaleEffect(bgAnimation ? 2.2 : 0)
                
                ZStack {

                        // random colors...
                    let colors: [Color] = [.red, .purple, .green, .yellow, .pink]

                        ForEach(1...6, id: \.self) { index in

                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 12, height: 12)
                                .offset(x: fireworkAnimation ? 80 : 40)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                        }
                    
                        ForEach(1...6, id: \.self) { index in

                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 8, height: 8)
                                .offset(x: fireworkAnimation ? 64 : 24)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                                .rotationEffect(.init(degrees: -45))
                        }
                    }
                .opacity(resetBG ? 1 : 0)
                .opacity(animationEnded ? 0 : 1)
                
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture(count: taps) {
            
                if tapComplete {
                    
                    //resettin back ...
                    updateFields(value: false)
                    return
                }
                
                if startAnimation {
    
                    return
                }
                
                isTapped = true
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.4, blendDuration: 0.4)) {
                    
                    startAnimation = true
                }
                //sequence animation
                //chain animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.4, blendDuration: 0.4)) {
                        
                        bgAnimation = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)) {
                            
                            resetBG = true
                        }
                        
                        //Fireworks...
                        withAnimation(.spring()) {
                            
                            fireworkAnimation = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                            
                            withAnimation(.easeOut(duration: 0.4)) {
                                
                                animationEnded = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                
                                tapComplete = true
                            }
                        }
                    }
                    
                    
                }
            }
            .onChange(of: isTapped) { newValue in
                
                if isTapped && !startAnimation {
                    
                    // setting everything to true
                    updateFields(value: true)
                }
                
                if !isTapped {
                    
                    updateFields(value: false)
                }
            }
    }
    
    func updateFields(value : Bool) {
        
        startAnimation = value
        bgAnimation = value
        resetBG = value
        fireworkAnimation = value
        animationEnded = value
        tapComplete = value
        isTapped = value
    }
}


