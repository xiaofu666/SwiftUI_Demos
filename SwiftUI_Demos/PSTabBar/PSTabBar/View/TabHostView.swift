//
//  TabHostView.swift
//  PSTabBar
//
//  Created by Xiaofu666 on 2024/8/29.
//

import SwiftUI

struct TabHostView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 12) {
                Text("Home")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.background)
                
                ForEach(1...50, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.background)
                        .frame(height: 45)
                }
            }
            .padding(15)
        }
        .safeAreaPadding(.top, 50)
        .safeAreaPadding(.bottom, 120)
    }
}

#Preview {
    TabHostView()
}
