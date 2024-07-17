//
//  ContentView.swift
//  FacebookGradientMask
//
//  Created by Xiaofu666 on 2024/7/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        ForEach(messages) { message in
                            MessageCardView(screenProxy: proxy, message: message)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Message")
            }
        }
    }
}

struct MessageCardView: View {
    var screenProxy: GeometryProxy
    var message: Message
    
    var body: some View {
        Text(message.message)
            .padding(10)
            .foregroundStyle(message.isReply ? Color.primary : .white)
            .background {
                if message.isReply {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                } else {
                    GeometryReader {
                        let size = $0.size
                        let rect = $0.frame(in: .global)
                        let screenSize = screenProxy.size
                        let safeArea = screenProxy.safeAreaInsets
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.linearGradient(colors: [
                                Color("C1"),
                                Color("C2"),
                                Color("C3"),
                                Color("C4"),
                            ], startPoint: .top, endPoint: .bottom))
                            .mask(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: size.width, height: size.height)
                                    .offset(x: rect.minX, y: rect.minY)
                            }
                            .offset(x: -rect.minX, y: -rect.minY)
                            .frame(width: screenSize.width, height: screenSize.height + safeArea.top + safeArea.bottom)
                    }
                }
            }
            .frame(maxWidth: 250, alignment: message.isReply ? .leading : .trailing)
            .frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
    }
}

#Preview {
    ContentView()
}
