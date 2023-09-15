//
//  ShimmerAnimationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/30.
//

import SwiftUI


struct ShimmerAnimationView : View {
    
    @State var multiColor = false
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                if #available(iOS 15.0, *) {
                    Text("Hello World!")
                        .shimmer()
                } else {
                    // Fallback on earlier versions
                }
                
                TextShimmer(text: "Kavsoft", mutiColor: $multiColor)
                
                Toggle(isOn: $multiColor, label: {
                    Text("Enable Multi Color")
                        .font(.title)
                        .fontWeight(.bold)
                })
                .padding()
            }
            .preferredColorScheme(.light)
        }
    }
}


struct TextShimmer : View {
    
    var text : String
    @State var animation = false
    @Binding var mutiColor : Bool
    var body: some View {
        
        ZStack {
            
            Text(text)
                .font(.system(size: 75, weight: .bold))
                .foregroundColor(Color.white.opacity(0.25))
            
            HStack(spacing: 0) {
                
                ForEach(0..<text.count, id: \.self) { index in
                    
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: 75, weight: .bold))
                        .foregroundColor(mutiColor ? randomColor() : Color.white)
                }
            }
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(1), Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .padding(20)
                    .offset(x: -250)
                    .offset(x: animation ? 500 :0)
            )
            .onAppear(perform: {
                
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                    animation.toggle()
                }
            })
        }
    }
    
    func randomColor()->Color {
        
        let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        
        return Color(color)
    }
}

struct ShimmerAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerAnimationView()
    }
}
