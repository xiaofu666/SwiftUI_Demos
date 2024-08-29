//
//  Home.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/28.
//

import SwiftUI

struct Home: View {
    @State private var activeTab: Tab = .play
    
    var body: some View {
        ZStack(alignment: .bottom ) {
            TabHostView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBar(activeTab: $activeTab)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Rectangle()
                .fill(Color.primary)
                .ignoresSafeArea()
        }
        .persistentSystemOverlays(.hidden)
        .overlay {
            GeometryReader { proxy in
                let size = proxy.size
                
                CustomHeaderView(size: size)
            }
        }
    }
}

#Preview {
    Home()
}
