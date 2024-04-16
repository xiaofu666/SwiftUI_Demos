//
//  ContentView.swift
//  ThreeColorAnimationView
//
//  Created by Lurich on 2023/9/25.
//

import SwiftUI

struct ContentView: View {
    
    var width: CGFloat = 110
    var space: CGFloat = 10
    var time: CGFloat = 0.3
    //animation properties
    @State var offsets: [CGSize] = Array(repeating: .zero, count: 3)
    
    //static offsets for one full complete rotation
    
    // so after one complete roatation it will again fire animation
    // for that were going to use timer..
    
    //just cancel timer when new page open or closed...
    @State var timer = Timer.publish(every: 0.3 * 3 * 4, on: .current, in: .common).autoconnect()
    
    @State var delayTime : Double = 0
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            
            
            VStack {
                HStack(spacing: space) {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: (width - space), height: (width - space))
                        .offset(offsets[0])
                }
                .frame(width: (width * 2 - space), alignment: .leading)
                
                HStack(spacing: space) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: (width - space), height: (width - space))
                        .offset(offsets[1])
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: (width - space), height: (width - space))
                        .offset(offsets[2])
                }
            }
            .frame(height: (width * 2 - space), alignment: .top)
        }
        .onAppear {
            doAnimation()
        }
        .onReceive(timer) { _ in
            print("re Do anitation")
            delayTime = 0
            doAnimation()
        }
    }
    
    func  doAnimation() {
        //doing our animation here...
        
        let locations: [CGSize] = [
                    // rotation1
                    CGSize(width: width, height: 0),
                    CGSize(width: 0, height: -width),
                    CGSize(width: -width, height: 0),
                    // rotation2
                    CGSize(width: width, height: width),
                    CGSize(width: width, height: -width),
                    CGSize(width: -width, height: -width),
                    // rotation3
                    CGSize(width: 0, height: width),
                    CGSize(width: width, height: 0),
                    CGSize(width: 0, height: -width),
                    //final reseting rotation....
                    CGSize(width: 0, height: 0),
                    CGSize(width: 0, height: 0),
                    CGSize(width: 0, height: 0),
                ]
        
        //since we have three offsets so were going to convert this array to subarrays of mx three elements
        //you can directly declare as subarrays..
        //Im doing like this its you choice
        
        var tempOffsets: [[CGSize]] = []
        var currentSet: [CGSize] = []
        for value in locations {
            currentSet.append(value)
            if currentSet.count == 3 {
                tempOffsets.append(currentSet)
                currentSet.removeAll()
            }
        }
        
        if !currentSet.isEmpty {
            tempOffsets.append(currentSet)
            currentSet.removeAll()
        }
        
        for offset in tempOffsets {
            for index in offset.indices {
                //each box shift will take 0.5 sec to finish...
                //so delay will be 0.3 and its multiplies
                doAnimation(delay:.now() + delayTime, value: offset[index], index: index)
                delayTime += time
            }
        }
    }
    
    func  doAnimation(delay: DispatchTime, value: CGSize, index: Int) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            withAnimation(Animation.easeInOut(duration: time + 0.2)) {
                self.offsets[index] = value
            }
        }
    }
}

#Preview {
    ContentView()
}
