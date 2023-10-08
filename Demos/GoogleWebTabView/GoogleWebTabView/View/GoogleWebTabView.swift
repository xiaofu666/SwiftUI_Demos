//
//  Home.swift
//  GoogleWebTabView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

struct GoogleWebTabView: View {
    
    @StateObject var pageData = WebPageViewModel()
    
    @Namespace var nameSpace
    
    let colunms = Array(repeating: GridItem(.flexible(), spacing: 45), count: 2)
    
    var body: some View {
       
        VStack {
            
            HStack {
                
                Image(systemName: "eyeglasses")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(pageData.selectedTab == "private" ? .black : .white)
                    .frame(width: 80, height: 45)
                    .background(
                        
                        ZStack {
                            
                            if pageData.selectedTab != "private" {
                                
                                Color.clear
                            }
                            else {
                                
                                Color.white
                                    .cornerRadius(10)
                                    .matchedGeometryEffect(id: "Tab", in: nameSpace)
                                    
                            }
                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            pageData.selectedTab = "private"
                        }
                    }
                
                Text("\(pageData.urls.count)")
                    .frame(width: 35, height: 35)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(pageData.selectedTab == "tabs" ? Color.black : Color.white, lineWidth: 3))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(pageData.selectedTab == "tabs" ? .black : .white)
                    .frame(width: 80, height: 45)
                    .background(
                        
                        ZStack {
                            
                            if pageData.selectedTab != "tabs" {
                                
                                Color.clear
                            }
                            else {
                                
                                Color.white
                                    .cornerRadius(10)
                                    .matchedGeometryEffect(id: "Tab", in: nameSpace)
                            }
                        }
                    )
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            pageData.selectedTab = "tabs"
                        }
                    }
                
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(pageData.selectedTab == "device" ? .black : .white)
                    .frame(width: 80, height: 45)
                    .background(
                        
                        ZStack {
                            
                            if pageData.selectedTab != "device" {
                                
                                Color.clear
                            }
                            else {
                                
                                Color.white
                                    .cornerRadius(10)
                                    .matchedGeometryEffect(id: "Tab", in: nameSpace)
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation {
                            pageData.selectedTab = "device"
                        }
                    }
            }
            .background(Color.white.opacity(0.15))
            .cornerRadius(15)
            .padding(.top)
            
            if pageData.selectedTab == "tabs" {
                ScrollView {
                    
                    LazyVGrid(columns:colunms, spacing: 20, content: {
                        
                        ForEach(pageData.urls) { page in
                            
                            WebView(url: page.url)
                                .frame(height: 200)
                                .cornerRadius(15)
                                .onDrag({
                                    
                                    pageData.currentPage = page
                                    
                                    return NSItemProvider(contentsOf: URL(string: "\(page.id)")!)!
                                })
                                .onDrop(of: [.url], delegate: DropViewDelegate(page: page, pageData: pageData))
                        }
                    })
                    .padding()
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        
        
    }
}

struct GoogleWebTabView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleWebTabView()
    }
}
