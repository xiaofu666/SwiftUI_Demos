//
//  ContentView.swift
//  OnBoarding
//
//  Created by Xiaofu666 on 2025/8/16.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnBoarding: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Apple Games")
        }
        .sheet(isPresented: $showOnBoarding) {
            AppleOnBoardingView(tint: .red, title: "Welcome To Apple Games") {
                /// YOUR APP ICON HERE
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size:50))
                    .frame(width: 100,height:100)
                    .foregroundStyle(.white)
                    .background(.red.gradient, in: .rect(cornerRadius: 25))
                    .frame(height: 180)
            } cards: {
                // Cards
                AppleOnBoardingCard(symbol: "list.bullet", title:"See What's New, Just for you", subTitle:"Explore whats's happening in your games and what to play next.")
                
                AppleOnBoardingCard(symbol: "person.2", title: "play and Compete with Friends", subTitle: "challenge friends, see what they're playing, and play together.")
                
                AppleOnBoardingCard(symbol: "square.stack", title:"All Your Games in One place", subTitle:"Access your full game library from the App Store and Apple Arcade.")
            } footer: {
                /// YOUR FOOTER HERE
                VStack(alignment:.leading, spacing: 6) {
                    Image(systemName:"person.3.fill").foregroundStyle(.red)
                    
                    Text("Your gameplay information, including what you play and your game activity, is used to improve Game Center.")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 15)
            } onContinue: {
                print("continue")
                showOnBoarding = false
            }
        }
    }
}

#Preview {
    ContentView()
}
