//
//  TabButton.swift
//  TwitterProfileScrollingView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

enum TabType: String, CaseIterable {
    case rounded = "rounded"
    case line = "line"
}

struct TabButton: View {
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    var type: TabType = .rounded
    var titleColor: Color = .white
    var bgColor: Color = .black
    var body: some View {
        Button {
            withAnimation(.spring()) {
                currentTab = title
            }
        } label: {
            if type == .rounded {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(currentTab == title ? titleColor : bgColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical ,8)
                    .background(
                        ZStack {
                            if currentTab == title {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(bgColor)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
            } else {
                VStack {
                    Text(title)
                        .fontWeight(.semibold)
                        .foregroundColor(titleColor)
                    ZStack {
                        if currentTab == title {
                            Capsule()
                                .fill(titleColor)
                                .shadow(radius: 15)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                                .frame(height: 3.5)
                        }
                        else {
                            Capsule()
                                .fill(.clear)
                                .frame(height: 3.5)
                        }
                    }
                }
            }
        }
    }
}

