//
//  SnapCarousel.swift
//  CarouselSliderView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

//Tp for Accepting List....
struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var  content:(T) -> Content
    var  list : [T]
    //properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    var isOffset: Bool
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items:[T], isOffset: Bool = false, @ViewBuilder content: @escaping (T) -> Content){
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
        self.isOffset = isOffset
    }
    
    // offset ....
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        
        GeometryReader { proxy in
            
            // setting correct width for snap carousel....
            // on sided snap caorusel
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                
                ForEach(list){item in
                    content(item)
                        .frame(width: proxy.size.width > trailingSpace ? (proxy.size.width - trailingSpace) : 0)
                        .offset(y: getOffset(item: item, width: width))
                }
            }
            //spacing will be horizontal padding....
            .padding(.horizontal, spacing)
            // setting only after oth index...
            .offset(x: (CGFloat(currentIndex) * -width) + (isOffset ? (currentIndex != 0 ? adjustMentWidth : 0) : adjustMentWidth) + offset)
            .gesture(
            
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        
                        // updating current index...
                        let offsetX = value.translation.width
                        
                        //were going to convert the tranlastion into progress(0- 1)
                        //and round the value....
                        //based on the progress increasing or decreasing the currentIndex.
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                    })
                    .onChanged({ value in
                        
                        //updating only index...
                        
                        // updating current index...
                        let offsetX = value.translation.width
                        
                        //were going to convert the tranlastion into progress(0- 1)
                        //and round the value....
                        //based on the progress increasing or decreasing the currentIndex.
                        
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        //Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
    
    //moving view based on scroll offset....
    func getOffset(item : T, width: CGFloat) -> CGFloat {
        
        //progress....
        //shifting Current Item to Top
        let progress = ((offset < 0 ? offset : -offset) / width) * 60
        
        //max 60
        //minus from 60
        let topOffset = -progress < 60 ? progress : -(progress + 120)
        
        let previous = getIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        
        let next = getIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0
        
        //safty check between o to max list size...
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next) : 0
        
        return getIndex(item: item) == currentIndex ? -60 - topOffset : checkBetween

    }
    
    // fetching index...
    func getIndex(item: T) -> Int {
        
        let index = list.firstIndex { currentItem in
            
            return currentItem.id == item.id
        } ?? 0
        
        return index
    }
}
