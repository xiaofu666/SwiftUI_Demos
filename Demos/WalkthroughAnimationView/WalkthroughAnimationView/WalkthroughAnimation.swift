//
//  Home1.swift
//  SwiftUI_iOS17_Demo
//
//  Created by Lurich on 2023/6/26.
//  WalkthroughAnimation

import SwiftUI

struct WalkthroughAnimation: View {
    @State private var intros: [Intro] = sampleIntros
    @State private var activeIntro: Intro?
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets
            
            VStack(spacing: 0, content: {
                if let activeIntro {
                    Rectangle()
                        .fill(activeIntro.bgColor)
                        .padding(.bottom, -30)
                        .overlay {
                            Circle()
                                .fill(activeIntro.circleColor)
                                .frame(width: 40, height: 40)
                                .background(alignment: .leading, content: {
                                    Capsule()
                                        .fill(activeIntro.bgColor)
                                        .frame(width: size.width)
                                })
                                .background(alignment: .leading) {
                                    Text(activeIntro.text)
                                        .font(.largeTitle)
                                        .foregroundStyle(activeIntro.textColor)
                                        .frame(width: textSize(activeIntro.text))
                                        .offset(x: 10)
                                        .offset(x: activeIntro.textOffset)
                                }
                                .offset(x: activeIntro.circleOffset)
                        }
                }
                
                LoginButtons()
                    .padding(.bottom, safeArea.bottom)
                    .padding(.top, 10)
                    .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 8)
            })
            .ignoresSafeArea()
        }
        .task {
            if activeIntro == nil {
                activeIntro = intros.first
                let nanoSecond = UInt64(1_000_000_000 * 0.15)
                try? await Task.sleep(nanoseconds: nanoSecond)
                animate(0, true)
            }
        }
    }
    
    @ViewBuilder
    func LoginButtons() -> some View {
        VStack(spacing: 12, content: {
            Button(action: {
                
            }, label: {
                Label("Continue With Apple", systemImage: "applelogo")
                    .foregroundStyle(.black)
                    .fillButton(.white)
            })
            
            Button(action: {
                
            }, label: {
                Label("Continue With Phone", systemImage: "phone.fill")
                    .foregroundStyle(.white)
                    .fillButton(.button)
            })
            
            Button(action: {
                
            }, label: {
                Label("Continue With Apple", systemImage: "envelope.fill")
                    .foregroundStyle(.white)
                    .fillButton(.button)
            })
            
            Button(action: {
                
            }, label: {
                Text("Login")
                    .foregroundStyle(.white)
                    .fillButton(.black)
                    .shadow(color: .white, radius: 1)
            })
        })
        .padding(15)
    }
    
    func animate(_ index: Int, _ loop: Bool = true) {
        if intros.indices.contains(index + 1) {
            activeIntro?.text = intros[index].text
            activeIntro?.textColor = intros[index].textColor
            
            withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
                activeIntro?.textOffset = -(textSize(intros[index].text) + 20)
                activeIntro?.circleOffset = (textSize(intros[index].text) + 20) / 2
            } completion: {
                withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
                    activeIntro?.textOffset = 0
                    activeIntro?.circleOffset = 0
                    activeIntro?.circleColor = intros[index + 1].circleColor
                    activeIntro?.bgColor = intros[index + 1].bgColor
                } completion: {
                    animate(index + 1, loop)
                }

            }
        } else {
            if loop {
                animate(0, loop)
            }
        }
    }
    
    func textSize(_ text: String) -> CGFloat {
        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
    }
}

#Preview {
    WalkthroughAnimation()
        .preferredColorScheme(.dark)
}

extension View {
    @ViewBuilder
    func fillButton(_ color: Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(color, in: .rect(cornerRadius: 15))
    }
}
