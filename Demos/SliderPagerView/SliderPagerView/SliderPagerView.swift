//
//  Home.swift
//  PagerTabs0830
//
//  Created by Lurich on 2021/8/31.
//

import SwiftUI

struct SliderPagerView: View {
    
    @State var currentSelection: Int = 0
    
    var body: some View {
       
        PagerTabView(tint: .black, selection: $currentSelection) {
            
            Image(systemName: "house.fill")
                .pageLabel()
            
            Image(systemName: "magnifyingglass")
                .pageLabel()
            
            Image(systemName: "person.fill")
                .pageLabel()
            
            Image(systemName: "gearshape")
                .pageLabel()
            
        } content: {
            
            Color.red
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            Color.green
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            Color.yellow
                .pageView(ignoresSafeArea: true, edges: .bottom)
            
            Color.purple
                .pageView()
        }
        .padding(.top)
        .ignoresSafeArea(.container, edges: .bottom)

    }
}

struct SliderPagerView_Previews: PreviewProvider {
    static var previews: some View {
        
        SliderPagerView()
    }
}
