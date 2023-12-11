//
//  ListHeaderAnimationView.swift
//  ElasticHeader0413
//
//  Created by Lurich on 2022/4/13.
//

import SwiftUI

@available(iOS 15.0, *)
struct ListHeaderAnimationView: View {
    
    @State var currentType: String = "Popular"
    @Namespace var animation
    private var albumData = AlbumData()
    
    @State var headerOffsets: (CGFloat, CGFloat) = (0, 0)

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView()
                //mark pinned header with content
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        VStack {
                            albumData.SongsList()
                                .padding()
                        }
                        .background {
                            Color.white
                        }
                    } header: {
                        
                        PinnedHeaderView()
                            .background(Color.black)
                            .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
                            .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $headerOffsets.1))
                    }
                }
                .background {
                    Color.black
                }
            }
        }
        .overlay(content: {
            
            Rectangle()
                .fill(.black)
                .frame(height: 50)
                .frame(maxHeight:.infinity, alignment: .top)
                .opacity(headerOffsets.0 < 5 ? 1 : 0)
        })
        .coordinateSpace(name: "ListHeaderAnimationView")
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
    }
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("ListHeaderAnimationView")).minY
            let size = proxy.size
            let height = size.height + minY
            Image("BGIMG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height:height > 0 ? height : 0, alignment: .top)
                .overlay{
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [
                            .clear,
                            .black.opacity(0.8)
                        ], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 13) {
                            HStack(alignment: .bottom, spacing: 10) {
                                Text("Ariana Grande")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .background{
                                        Circle()
                                            .fill(.white)
                                            .padding(3)
                                    }
                            }
                            
                            Label {
                                Text("Monthly Listeners")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.7))
                            } icon: {
                                Text("62, 354, 659")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .font(.caption)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        .frame(maxWidth:.infinity, alignment: .leading)
                    }
                }
//                .cornerRadius(15)
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
    
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let types: [String] = ["Popular", "Albums", "Songs", "Fans also like", "About"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(types, id: \.self) {type in
                    VStack(spacing: 12) {
                        Text(type)
                            .fontWeight(.semibold)
                            .foregroundColor(currentType == type ? .white : .gray)
                        
                        ZStack {
                            if currentType == type {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 4)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 25)
            .padding(.bottom, 5)
        }
        
    }
}

@available(iOS 15.0, *)
struct ListHeaderAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderAnimationView()
    }
}
