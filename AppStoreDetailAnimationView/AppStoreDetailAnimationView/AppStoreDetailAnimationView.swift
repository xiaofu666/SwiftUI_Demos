//
//  Home.swift
//  AppStoreShowDetailList
//
//  Created by Lurich on 2022/4/7.
//

import SwiftUI

@available(iOS 15.0, *)
struct AppStoreDetailAnimationView: View {
    
    @State var currentItem: Today?
    @State var showDetailPage: Bool = false
    @Environment(\.dismiss) var dismiss
    @Namespace var animation
    
    @State var animationView: Bool = false
    @State var animateContent: Bool = false
    
    @State var scrollOffset: CGFloat = 0
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("MONDAY 4 APRIL")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        Text("Today")
                            .font(.largeTitle.bold())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                   
                    Button {
                                        
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .opacity(showDetailPage ? 0 : 1)
                
                ForEach(todayItenms) { item in
                    Button {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            currentItem = item
                            showDetailPage = true
                        }
                        
                    } label: {
                        CardView(item: item)
                            .scaleEffect(currentItem?.id == item.id && showDetailPage ? 1 : 0.93)
                    }
                    .buttonStyle(ScaledButtonStyle())
                    .opacity(showDetailPage ? (currentItem?.id == item.id ? 1 : 0) : 1)
                }
            }
            .padding(.vertical)
        }
        .coordinateSpace(name: "AppStoreAnimationView")
        .overlay{
            if let currentItem = currentItem, showDetailPage {
                DetailView(item: currentItem)
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
        .background(alignment: .top) {
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black)
                .frame(height: animationView ? nil : 350, alignment: .top)
                .scaleEffect(animationView ? 1 : 0.93)
                .opacity(animationView ? 1 : 0)
                .ignoresSafeArea()
        }
    }
    
    //Mark CardView
    @ViewBuilder
    func CardView(item: Today) -> some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            ZStack(alignment: .topLeading) {
                
                //banner img
                GeometryReader { proxy in
                    
                    let size = proxy.size
                    
                    Image(item.artWork)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(ClipCornerShape(corners: [.topLeft, .topRight], radius: 15))
                }
                .frame(height: 400)
                LinearGradient(colors: [
                    
                    .black.opacity(0.5),
                    .black.opacity(0.2),
                    .clear
                ], startPoint: .top, endPoint: .bottom)
                .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(item.platformTitle.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(item.bannerTitle)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(.white)
                .padding()
                .offset(y: currentItem?.id == item.id && animationView ? getSafeArea().top : 0)
                
            }
            
            HStack(spacing: 12) {
                
                Image(item.appLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(item.platformTitle.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(item.appName.uppercased())
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    
                    Text(item.appDescription.uppercased())
                        .font(.caption)
                        .foregroundColor(.gray)
                }
//                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    dismiss()
                } label: {
                    
                    Text("下载")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 20)
                        .background{
                            
                            Capsule()
                                .fill(.ultraThinMaterial)
                        }
                }

            }
            .padding([.horizontal, .bottom])
        }
        .background {
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color.black)
        }
        .matchedGeometryEffect(id: item.id, in: animation)
    }
    
    @ViewBuilder
    func DetailView(item: Today) -> some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack {
                
                CardView(item: item)
                    .scaleEffect(animationView ? 1 : 0.93)
                
                VStack(spacing: 15) {
                    
                    Text(dummyText)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10)
                        .padding(.bottom, 20)
                        
                    
                    Divider()
                    
                    Button {
                        
                    } label: {
                        
                        Label {
                            
                            Text("Share Story")
                        } icon: {
                            
                            Image(systemName: "square.and.arrow.up.fill")
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 25)
                        .background {
                            
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }

                    }

                }
                .foregroundColor(.white)
                .padding()
                .offset(y: scrollOffset > 0 ? scrollOffset : 0)
                .opacity(animateContent ?  1 : 0)
                .scaleEffect(animationView ? 1 : 0, anchor: .top)
            }
            .offset(y: scrollOffset > 0 ? -scrollOffset : 0)
            .getMinY(coordinateSpace: .named("AppStoreDetailAnimationView")) { offset in
                $scrollOffset.wrappedValue = offset
            }
        }
        .coordinateSpace(name: "AppStoreDetailAnimationView")
        .overlay(alignment: .topTrailing, content: {
            
            Button {
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.7)) {
                    
                    animateContent = false
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
                    
                    animationView = false
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.7).delay(0.1)) {
                    
                    currentItem = nil
                    showDetailPage = false
                }
            } label: {
                
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding()
            .padding(.top, getSafeArea().top)
            .opacity(animationView ? 1 : 0)
            
        })
        .onAppear{
            
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.7)) {
                
                animationView = true
            }
            
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.7).delay(0.05)) {
                
                animateContent = true
            }
        }
        .transition(.identity)
    }
    
}

@available(iOS 15.0, *)
struct AppStoreDetailAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AppStoreDetailAnimationView()
    }
}


// mark scaledButton Style
private struct ScaledButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
