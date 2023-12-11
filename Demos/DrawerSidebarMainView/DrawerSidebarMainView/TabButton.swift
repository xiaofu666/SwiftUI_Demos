//
//  TabButton.swift
//  Custom_Side_Menu
//
//  Created by Lurich on 2023/9/26.
//

import SwiftUI

struct TabButton: View {
    
    var image: String
    var title: String
    
    @Binding var selectedTab: String
    
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){
                selectedTab = title
            }
        }, label: {
            
            HStack(spacing : 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(selectedTab == title ? .blue : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            //Max Frame...
            .frame(maxWidth: UIScreen.main.bounds.width - 170,  alignment: .leading)
            .background(
                
                //hero Animation
                ZStack {
                    if selectedTab == title {
                        Color.white
                            .opacity(selectedTab == title ? 1 : 0)
                            .clipShape(ClipCornerShape(corners: [.topRight, .bottomRight], radius: 10))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
            
        })
    }
}

//指定方向加圆角 [topLeft, topRight, bottomLeft, bottomRight] 或 allCorners
///example :  ClipCornerShape(corners: [.topRight, .bottomRight], radius: 10)
struct ClipCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct TabButton2_Previews: PreviewProvider {
    static var previews: some View {
        DrawerSidebarMainView()
    }
}
