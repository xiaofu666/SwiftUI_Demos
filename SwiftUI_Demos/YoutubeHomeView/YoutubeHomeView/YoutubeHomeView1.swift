//
//  YoutubeHomeView1.swift
//  YoutubeHomeView
//
//  Created by Lurich on 2021/6/28.
//

import SwiftUI

private class HeaderViewModel: ObservableObject {
    @Published var startMinY : CGFloat = 0
    @Published var offset : CGFloat = 0
    @Published var headerOffset : CGFloat = 0
    @Published var topScrollOffset : CGFloat = 0
    @Published var bottomScrollOffset : CGFloat = 0
}
struct YoutubeHomeView1: View {
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let size = proxy.size
            YoutubeHomeView(safeArea: safeArea, size: size)
        }
    }
}

private struct YoutubeHomeView: View {
    var safeArea: EdgeInsets
    var size: CGSize
    
    @StateObject private var headerData = HeaderViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            HeaderView()
                .zIndex(1)
                .offset(y: headerData.headerOffset)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(1...6, id: \.self) { index in
                        Image("user\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width - 30, height: 250)
                            .cornerRadius(4)
                    }
                }
                .padding(.top, 70)
                .overlay(alignment: .top) {
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        DispatchQueue.main.async {
                            if headerData.startMinY == 0 {
                                headerData.startMinY = safeArea.top
                            }
                            let offset = headerData.startMinY - minY
                            if offset > headerData.offset {
                                headerData.bottomScrollOffset = 0
                                if headerData.topScrollOffset == 0 {
                                    headerData.topScrollOffset = offset
                                }
                                let progress = (headerData.topScrollOffset + getMaxOffset()) - offset
                                let offsetCondition = (getMaxOffset() + getMaxOffset()) >= progress && (getMaxOffset() - progress) <= getMaxOffset()
                                let headerOffset = offsetCondition ? -(getMaxOffset() - progress) : -getMaxOffset()
                                headerData.headerOffset = headerOffset
                                print("up++++++++",headerOffset)
                            }
                            
                            if offset < headerData.offset {
                                headerData.topScrollOffset = 0
                                if headerData.bottomScrollOffset == 0 {
                                    headerData.bottomScrollOffset = offset
                                }
                                withAnimation(.easeOut(duration: 0.25)) {
                                    let headerOffset = headerData.headerOffset
                                    headerData.headerOffset =  headerData.bottomScrollOffset > offset + 40 ? 0 : (headerOffset != -getMaxOffset() ? 0 : headerOffset)
                                }
                            }
                            headerData.offset = offset
                        }
                        return Color.clear
                    }
                    .frame(height: 1)
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
        }
    }
    
    //getting max top offset
    func getMaxOffset() -> CGFloat {
        return headerData.startMinY + (safeArea.top) + 10
    }
}

@available(iOS 15.0, *)
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@available(iOS 15.0, *)
private struct HeaderView: View {
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        HStack (spacing: 20){
            Image(systemName: "play.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 10, height: 10)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.red)
                .cornerRadius(5)
            
            Text("Youtube")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .kerning(0.5)
                .offset(x: -10)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "display")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background((scheme == .dark ? Color.black : Color.white)
            .ignoresSafeArea(.all, edges: .top))
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}
