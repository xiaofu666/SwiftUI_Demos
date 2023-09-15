//
//  SFCapsuleIndicators.swift
//  OnBoardingAnimation0901
//
//  Created by Lurich on 2021/9/3.
//

import SwiftUI

struct CapsuleIndicators: View {
    
    var dataArr: [Any]
    
    var pageWidth: CGFloat
    
    @Binding var offset: CGFloat
    
    var body: some View {
        
        
        HStack(spacing:12) {

            ForEach(dataArr.indices, id: \.self) { index  in

                Capsule()
                    .fill(.white)
                //increasing width for only current index...
                    .frame(width: getIndex() == index ? 20 : 7, height: 7)
            }
        }
        .background(

            Capsule()
                .fill(.white)
                .frame(width: 20, height: 7)
                .offset(x: getIndicatorOffset())

            ,alignment: .leading
        )
        
    }
    
    
    // changing bg color based on offset ...
    func getIndex() -> Int {
        
        let progress = (offset / pageWidth).rounded()
        
        return  Int(progress)
    }
    
    //offset for indicator...
    func getIndicatorOffset() -> CGFloat {
        
        let progress = offset / pageWidth
        
        //12 = spacing
        //7 = circleSize
        let maxWidth: CGFloat = 12 + 7
        
        return progress * maxWidth
    }
}


