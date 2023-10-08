//
//  PagerTabView.swift
//  PagerTabs0830
//
//  Created by Lurich on 2021/8/31.
//

import SwiftUI

struct PagerTabView<Content: View, Label: View>: View {
    
    var content: Content
    var label: Label
    //Tint....
    var tint: Color
    //selection...
    @Binding var selection: Int
    
    
    init(tint: Color, selection:Binding<Int>, @ViewBuilder labels: @escaping () -> Label,@ViewBuilder content: @escaping () -> Content) {
        
        self.content = content()
        self.label = labels()
        self.tint = tint
        self._selection = selection
        
    }
    
    // Offset for page ScrollView
    @State var offset: CGFloat = 0
    
    @State var maxTabs: CGFloat = 0
    
    @State var tabOffset: CGFloat = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                
                label
            }
            .overlay(
            
                HStack(spacing:0) {
                
                    ForEach(0..<Int(maxTabs), id: \.self) { index in
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.01))
                            .onTapGesture {
                                
                                let newOffset = CGFloat(index) * getScreenRect().width
                                self.offset = newOffset
                            }
                    }
                }
            )
            .foregroundColor(tint)
            
            // Indicator...
            Capsule()
                .fill(tint)
                .frame(width: maxTabs == 0 ? 0 : (getScreenRect().width / maxTabs / 2), height: 5)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: getScreenRect().width / maxTabs / 4 +  tabOffset)
            
            OffsetPageTabView(selection: $selection, offset: $offset) {
                
                HStack(spacing: 0) {
                    
                    content
                }
                //Getting How many tabs are there by getting the total Content Size...
                .overlay(
                    
                    GeometryReader { proxy in
                    
                        Color.clear
                        .preference(key: TabPreferenceKey.self, value: proxy.frame(in: .global))
                    }
                )
                //when value changes...
                .onPreferenceChange(TabPreferenceKey.self) { proxy in
                    
                    let minX = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenRect().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
                    //print(maxTabs)
                    
                    //getting tab offset
                    let progress = minX / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    
                    self.tabOffset = tabOffset
                    
                    self.maxTabs = maxTabs
                }
            }
            
        }
    }
}

//geometry preference...
struct TabPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .init()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        
        value = nextValue()
    }
}



//extension view  for pagelablel and pageview modeifiers...
extension View {
    
    func pageLabel() -> some View {
        //just filling all empty space
        self.frame(maxWidth: .infinity, alignment: .center)
        
    }
    
    //modifications for safearea ignoring....
    //same for pageView
    func pageView(ignoresSafeArea: Bool = false, edges: Edge.Set = []) -> some View {
        //just filling all empty space
        self.frame(width: getScreenRect().width, alignment: .center)
            .ignoresSafeArea(ignoresSafeArea ? .container : .init(), edges: edges)
    }
}

extension View {
    func getScreenRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}
