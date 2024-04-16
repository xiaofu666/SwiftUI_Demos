//
//  SFWaveFrom.swift
//  SwiftUIBaseCategory
//
//  Created by Lurich on 2021/7/6.
//

import SwiftUI


@available(iOS 15.0, *)
struct WaveFrom: View {
    
    //水波纹颜色
    var color: Color
    //水波纹波动幅度
    var amplify: CGFloat
    
    //true 向右流动。false 向左流动
    var isReversed: Bool
    
    var body: some View {
        
        //using time line view  for peroidc updates...
        
        TimelineView(.animation) { timeLine in
            
            
            //Canvas view for drawing wave...
            Canvas { context, size  in
                
                // getting current time ...
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                
                //animating the wave using current time...
                let angle = timeNow.remainder(dividingBy: 2)
                
                //calculating offset...
                let offset = angle * size.width
                
//                context.draw(Text("\(offset)"), at: CGPoint(x: size.width / 2, y: 100))
                //you can see it now shifts to screen width...
                
                
                
                //you can see it moves between -1.5 - 1.5...
                //ie 3/2 = 1.5
                //if  2 means -1 to 1 ....
            
                //moving the whole view...
                //simple and easy wave animation....
                context.translateBy(x: isReversed ? offset : -offset, y: 0)
                
                
                
                // using swiftui path for drawing wave....
                context.fill(getPath(size: size), with: .color(color))
                
                // drawing curve front and back
                // so that tranlation will be lool like wave annimation
                context.translateBy(x: -size.width, y: 0)
                context.fill(getPath(size: size), with: .color(color))
                
                context.translateBy(x: size.width * 2, y: 0)
                context.fill(getPath(size: size), with: .color(color))
            }
        }
        
    }
    
    
    func  getPath(size: CGSize) ->Path{
        
        return Path{path in
            
            let  midHeight = size.height / 2
            
            let width = size.width
            
            //moving the wave to center leading...
            path.move(to: CGPoint(x: 0, y: midHeight))
            
            // drawing curve....
            
            // for bottom
            path.addCurve(to: CGPoint(x: width, y: midHeight), control1: CGPoint(x: width * 0.4, y: midHeight +  amplify), control2: CGPoint(x: width * 0.65, y: midHeight - amplify))
            
            // filling the bottom remaining area...
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
            
            
            
        }
    }
    
}
