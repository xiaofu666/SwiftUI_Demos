//
//  CustomStackView.swift
//  WeatherAPPUI
//
//  Created by Lurich on 2021/6/17.
//

import SwiftUI

@available(iOS 15.0, *)
struct CustomStackView<Title: View, Content:View>: View {
    
    var titleView: Title
    var contentView: Content
    
    @State var topOffset: CGFloat = 0
    @State var bottomOffset: CGFloat = 0
    
    
    init(@ViewBuilder titleView:@escaping () ->Title, @ViewBuilder contentView:@escaping () ->Content) {
        
        self.contentView = contentView()
        self.titleView = titleView()
    }
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(.ultraThinMaterial, in: ClipCornerShape(corners: bottomOffset < 38 ? .allCorners : [.topLeft, .topRight], radius: 12))
                .zIndex(1)
            
            
            VStack {
                
                Divider()
                
                contentView
                    .padding()
                
            }
            .background(.ultraThinMaterial, in: ClipCornerShape(corners: [.bottomLeft, .bottomRight], radius: 12))
            
            //moving content upward
            .offset(y: topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            //clipping to avoid backgorund overlay
            .clipped()
            .opacity(getOpacity())
            
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        // stopping view @120....
        .offset(y: topOffset >= 120 ? 0 : -topOffset + 120)
        .modifier(CornerModifier(bottomOffset: $bottomOffset))
        .overlay(
            overView()
        )
        
    }
    
    
    //opacity....
    func getOpacity() -> CGFloat {
        
        if  bottomOffset < 28 {
            
            let progress = bottomOffset / 28
            
            return progress
        }
        else {
            
            return 1
        }
    }
    
    @ViewBuilder
    func overView() -> some View {
        
        GeometryReader { proxy -> Color in
            
            let minY = proxy.frame(in: .global).minY
            let maxY = proxy.frame(in: .global).maxY
            
            DispatchQueue.main.async {
                
                self.topOffset = minY
                
                //reducing 120...
                self.bottomOffset = maxY - 120
                print(maxY)
                //thus we will get our title height 38...
                
                
            }
            
            return Color.clear
        }
    }
    
}

@available(iOS 15.0, *)
struct CustomStackView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        WeatherAPPUI()
    }
}


struct CornerModifier: ViewModifier {
    
    @Binding var bottomOffset: CGFloat
    
    func body(content: Content) -> some View {
        
        if bottomOffset < 38 {
            content
        }
        else {
            
            content.cornerRadius(12)
        }
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


