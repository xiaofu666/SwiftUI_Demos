//
//  IntroView.swift
//  IntroAnimation1216
//
//  Created by Lurich on 2022/12/16.
//

import SwiftUI

@available(iOS 16.0, *)
struct IntroView: View {
    
    @State var showWalkThroughScrrens: Bool = false
    @State var currentIndex: Int = 0
    @State var showHomeView: Bool = false
    var body: some View {
        ZStack {
            if showHomeView {
                NavigationStack {
                    Text("Hello World!")
                        .navigationTitle("Home")
                }
                .transition(.move(edge: .trailing))
            } else {
                ZStack {
                    Color("BG")
                        .ignoresSafeArea()
                    
                    IntroScreen()
                        
                    WalkThroughScreens()
                    
                    NavBar()
                }
                .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showWalkThroughScrrens)
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: showHomeView)
    }
    
    @ViewBuilder
    func WalkThroughScreens() -> some View {
        let isLast = currentIndex == intros.count
        GeometryReader {
            let size = $0.size
            ZStack {
                ForEach(intros.indices, id: \.self) { index in
                    ScreeenView(size: size, index: index)
                }
                
                WelcomeView(size: size, index: intros.count)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                
                ZStack {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .scaleEffect(!isLast ? 1 : 0.001)
                        .frame(height: !isLast ? nil : 0)
                        .opacity(!isLast ? 1 : 0)
                    
                    HStack{
                        Text("Sign Up")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 15)
                    .scaleEffect(isLast ? 1 : 0.001)
                    .frame(height: isLast ? nil : 0)
                    .opacity(isLast ? 1 : 0)
                }
                .frame(width: isLast ? size.width / 1.5 : 55, height: isLast ? 50 : 55)
                .foregroundColor(.white)
                .background {
                    RoundedRectangle(cornerRadius: isLast ? 10 : 30, style: isLast ? .continuous : .circular)
                        .fill(Color("Blue"))
                }
                .onTapGesture {
                    if currentIndex == intros.count {
                        showHomeView = true
                    } else {
                        currentIndex += 1
                    }
                }
                .offset(y:isLast ? -40 : -0)
                .animation(.interactiveSpring(response: 0.91, dampingFraction: 0.85, blendDuration: 0.5), value: isLast)
                
                    
            }
            .overlay(alignment: .bottom, content: {
                let isLast = currentIndex == intros.count
                
                HStack(spacing: 5) {
                    Text("Already have an account?")
                        .font(.title3)
                        .foregroundColor(.gray)
                    
                    Button("Login") {
                        
                    }
                    .font(.title3)
                    .foregroundColor(Color("Blue"))
                }
                .offset(y: isLast ? -12 : 100)
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5), value: isLast)
            })
            .offset(y: showWalkThroughScrrens ? 0 : size.height)
        }
    }
    
    @ViewBuilder
    func ScreeenView(size: CGSize, index: Int) -> some View {
        let intro = intros[index]
        
        VStack(spacing: 10) {
            Text(intro.title)
                .font(.title)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Text(dummyText)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
            
            Image(intro.image)
                .resizable()
                .aspectRatio(contentMode:.fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.2 : 0), value: currentIndex)
        }
    }
    
    @ViewBuilder
    func WelcomeView(size: CGSize, index: Int) -> some View {
        
        VStack(spacing: 10) {
            Image("Book 5")
                .resizable()
                .aspectRatio(contentMode:.fit)
                .frame(height: 250, alignment: .top)
                .padding(.horizontal, 20)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0 : 0.2).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            Text("Welcome")
                .font(.title)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentIndex == index ? 0.2 : 0).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            Text("Stay organised and live stress-free with\nyou-do app.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .offset(x: -size.width * CGFloat(currentIndex - index))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1).delay(currentIndex == index ? 0.1 : 0), value: currentIndex)
            
            
        }
        .offset(y: -30)
    }
    
    @ViewBuilder
    func NavBar() -> some View {
        
        let isLast = currentIndex == intros.count
        
        HStack {
            Button {
                if currentIndex > 0 {
                    currentIndex -= 1
                } else {
                    showWalkThroughScrrens.toggle()
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("Blue"))
            }
            
            Spacer()
            
            Button("Skip") {
                currentIndex = intros.count
            }
            .font(.body)
            .foregroundColor(Color("Blue"))
            .opacity(isLast ? 0 : 1)
            .animation(.easeOut, value: isLast)
        }
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: showWalkThroughScrrens ? 0 : -120)
    }
    
    @ViewBuilder
    func IntroScreen() -> some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 10) {
                Image("Book 4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height / 2)
                    .clipped()
                
                Text("Clearhead")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                Text(dummyText)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("Let's Begin")
                    .font(.body)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background {
                        Capsule()
                            .fill(Color("Blue"))
                    }
                    .onTapGesture {
                        showWalkThroughScrrens.toggle()
                    }
                    .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .offset(y: showWalkThroughScrrens ? -size.height : 0)
        }
        .ignoresSafeArea()
    }
}

@available(iOS 16.0, *)
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
