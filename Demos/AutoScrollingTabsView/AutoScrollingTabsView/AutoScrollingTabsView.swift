//
//  AutoScrollingTabsView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/5.
//

import SwiftUI

@available(iOS 16.0, *)
struct AutoScrollingTabsView: View {
    @State private var items: [AppItem] = []
    @State private var currentTab: String = ""
    @Namespace private var animation
    @State private var productsBaseOnType: [[AppItem]] = []
    @State private var animationDone: Bool = false
    
    //顶部tab跟随滚动,额外添加属性
    @State private var scrollableOffset: CGFloat = 0
    @State private var initialOffset: CGFloat = 0
    
    var body: some View {
        //顶部tab跟随滚动
        scrollViewType1()
        //顶部tab不跟随滚动
//        scrollViewType2()
    }
    
    @ViewBuilder
    func scrollViewType1() -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 15) {
                    ForEach(productsBaseOnType, id: \.self) { products in
                        productSectionView(products)
                    }
                }
                .getRectFor(key: "AutoScrollingTabsView", completion: { rect in
                    scrollableOffset = rect.minY - initialOffset
                })
            }
            .getRectFor(key: "AutoScrollingTabsView", completion: { rect in
                initialOffset = rect.minY
            })
            .safeAreaInset(edge: .top) {
                scrollableTabs(proxy)
                    .offset(y: scrollableOffset > 0 ? scrollableOffset - 1 : -1)
            }
        }
        .onAppear {
            for index in 1...10 {
                items.append(AppItem(name: "标题\(index)", num: Int.random(in: 20...100)))
            }
            currentTab = items[0].name
            
            guard productsBaseOnType.isEmpty else {
                return
            }
            var tmpArr: [AppItem] = []
            for item in items {
                tmpArr.removeAll()
                for i in 0...item.num {
                    tmpArr.append(AppItem(name: "第 \(i+1) 个 cell", source: item.name, color: Color.orange, num: Int.random(in: 10...100)))
                }
                productsBaseOnType.append(tmpArr)
            }
        }
        .coordinateSpace(name: "AutoScrollingTabsView")
        .navigationBarTitle("App Store")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.purple, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func scrollViewType2() -> some View {
        ScrollViewReader { proxy in
            scrollableTabs(proxy)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    ForEach(productsBaseOnType, id: \.self) { products in
                        productSectionView(products)
                    }
                }
            }
        }
        .onAppear {
            for index in 1...10 {
                items.append(AppItem(name: "标题\(index)", num: Int.random(in: 20...100)))
            }
            currentTab = items[0].name
            
            guard productsBaseOnType.isEmpty else {
                return
            }
            var tmpArr: [AppItem] = []
            for item in items {
                tmpArr.removeAll()
                for i in 0...item.num {
                    tmpArr.append(AppItem(name: "第 \(i+1) 个 cell", source: item.name, color: Color.orange, num: Int.random(in: 10...100)))
                }
                productsBaseOnType.append(tmpArr)
            }
        }
        .coordinateSpace(name: "AutoScrollingTabsView")
        .navigationBarTitle("App Store")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.purple, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func scrollableTabs(_ proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(items) { item in
                    Text(item.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .background(alignment: .bottom, content: {
                            if currentTab == item.name {
                                Capsule()
                                    .fill(.white)
                                    .frame(height: 5)
                                    .padding(.horizontal, -5)
                                    .offset(y: 15)
                                    .matchedGeometryEffect(id: "ANIMATION", in: animation)
                            }
                        })
                        .padding(.horizontal, 15)
                        .contentShape(Rectangle())
                        .id(item.name + item.name)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentTab = item.name
                                animationDone = true
                                proxy.scrollTo(item.name, anchor: .topLeading)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animationDone = false
                            }
                        }
                }
            }
            .padding(.vertical, 15)
            .onChange(of: currentTab) { oldValue, newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newValue + newValue, anchor: .center)
                }
            }
        }
        .background {
            Rectangle()
                .fill(.purple)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
    
    @ViewBuilder
    func productSectionView(_ products: [AppItem]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            if let product = products.first {
                Text(product.source)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            
            ForEach(products) { product in
                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(product.color)
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.name)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("副标题")
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                        
                        Text("$ \(product.num).00")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .getRectFor(key: "AutoScrollingTabsView", completion: { rect in
            let minY = rect.minY
            if (minY < 30 && -minY < (rect.midY / 2) && currentTab != products.type && !animationDone) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentTab = products.type
                }
            }
        })
        .frame(maxWidthVSHS: .infinity, alignment: .leading)
        .padding(15)
        .id(products.type)
    }
}

@available(iOS 16.0, *)
struct AutoScrollingTabsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AutoScrollingTabsView()
        }
    }
}

fileprivate extension [AppItem] {
    var type: String {
        if let first = self.first {
            return first.source
        }
        return "标题1"
    }
}

extension View {
    @ViewBuilder
    func getRectFor(key coordinateSpace: String, completion: @escaping (CGRect) -> ()) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let rect = proxy.frame(in: .named(coordinateSpace))
                Color.clear
                    .preference(key: RectKey.self, value:rect)
                    .onPreferenceChange(RectKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}
struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
