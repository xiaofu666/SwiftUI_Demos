//
//  SideTabView.swift
//  SpotifyUI
//
//  Created by Lurich on 2021/6/10.
//

import SwiftUI

struct SideTabView: View {
    
    // current tab
    @State var selectedTab = "house.fill"
    
    // volume
    @State var volume: CGFloat = 0.4
    
    @State var showSideBar = false
    
    var body: some View {
        
        // Side Tab Bar
        // Optimizing for smaller size ipone...
        
        VStack {
            
            Image("Logo1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipped()
                .padding(.top)
            
           
            VStack {
                
                TabButton_SongView(image: "house.fill", selectedTab: $selectedTab)
                
                TabButton_SongView(image: "safari.fill", selectedTab: $selectedTab)
                
                TabButton_SongView(image: "mic.fill", selectedTab: $selectedTab)
                
                TabButton_SongView(image: "clock.fill", selectedTab: $selectedTab)
            }
            // setting the tabs for half of the height so that remaining elements will get space...
            .frame(height: getScreenRect().height / 3)
            .padding(.top)
            
            Spacer(minLength:  getScreenRect().height < 750 ? 30 : 50)
            
            Button(action: {
                // checking and increasing volume...
                volume = volume + 0.1 < 1.0 ? volume + 0.1 : 1
                
            }, label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            })
            
            // custom volume progress view
            GeometryReader { proxy in
                
                // extracing progress bar height and based on that getting progress value...
                let height = proxy.frame(in: .global).height
                let progress = height * volume
                
                ZStack (alignment: .bottom){
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width:4)
                    
                    Capsule()
                        .fill(Color.white)
                        .frame(width:4, height: progress)
                        
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .padding(.vertical,  getScreenRect().height < 750 ? 10 : 20)
            
            Button(action: {
                // checking and decreasing volume...
                volume = volume - 0.1 > 0.0 ? volume - 0.1 : 0
                
            }, label: {
                Image(systemName: "speaker.wave.1.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            })
            
            Button(action: {
                
                withAnimation(.easeIn) {
                    
                    showSideBar.toggle()
                }
                
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.white)
                    .rotationEffect(.init(degrees:  showSideBar ? -180 : 0))
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            })
            .padding(.top,  getScreenRect().height < 750 ? 15 : 30)
            .padding(.bottom, getSafeArea().bottom == 0 ? 15 : 0)
            .offset(x: showSideBar ? 0 : 100)
            
        }
        //Max side tab bar width
        .frame(width: 80)
        .background(Color.black.ignoresSafeArea())
        .offset(x: showSideBar ? 0 : -100)
        //reclaiming the spacing by using negative spacing
        .padding(.trailing, showSideBar ? CGFloat(0) : -100)
        //change the stack position
        //so that the side tab bar will be on top...
        .zIndex(1.0)
    }
}

struct SideTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}


// Tab Button...
struct TabButton_SongView: View {
    
    var image: String
    @Binding var selectedTab: String
    
    var body: some View {
        
        Button(action: {
            withAnimation{selectedTab = image}
        }, label: {
            Image(systemName: image)
                .font(.title)
                .foregroundColor(selectedTab == image ? .white : Color.gray.opacity(0.6))
                .frame(maxHeight: .infinity)
        })
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
    
    func getSafeArea() -> UIEdgeInsets {
        let safeArea = getWindow().safeAreaInsets
        return safeArea
    }

    //MARK: ROOT View Controller
    func getWindow() -> UIWindow {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let window = screen.windows.first else {
            return .init()
        }
        return window
    }
}
