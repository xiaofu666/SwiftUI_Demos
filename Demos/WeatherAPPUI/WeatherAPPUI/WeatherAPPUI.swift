//
//  Home.swift
//  WeatherAPPUI
//
//  Created by Lurich on 2021/6/17.
//

import SwiftUI
import SpriteKit

@available(iOS 15.0, *)
struct WeatherAPPUI: View {
    
    @State var offset: CGFloat = 0
    
    var topEdge: CGFloat = getSafeArea().top
    
    // to avoid early starting of landing animation
    @State var showRain = true
    //were goingt to delay start it
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { proxy in
                
                Image("Logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            
            //Rain fall view
            GeometryReader{ _ in
                
                SpriteView(scene: RainFall(), options: [.allowsTransparency])
            }
            .ignoresSafeArea()
            .opacity(showRain ? 1 : 0)
            
            
            // mianview ..
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    //weather Data...
                    VStack(alignment: .center, spacing: 5) {
                        
                        Text("San Jose")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text(" 90° ")
                            .font(.system(size: 45))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        Text("Cloudy")
                            .foregroundStyle(.secondary)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        Text("H:113° L:105°")
                            .foregroundStyle(.primary)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                    }
                    .offset(y: -offset)
                    //For bottom drag effect...
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset())
                    
                    //custome data view...
                    VStack(spacing: 8) {
                        
                        //custom Stack
                        CustomStackView {
                            
                            // label Here...
                            Label {
                                
                                Text("Hourly Forecast")
                            } icon: {
                                
                                Image(systemName: "clock")
                            }
                            
                            
                        } contentView: {
                            
                            //content...
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack(spacing: 15) {
                                    
                                    ForecastView(time:"12 AM", celcius: 97, image: "sun.min")
                                    
                                    ForecastView(time:"1 PM", celcius: 97, image: "sun.haze")
                                    
                                    ForecastView(time:"2 PM", celcius: 97, image: "sun.min")
                                    
                                    ForecastView(time:"3 PM", celcius: 97, image: "cloud.sun")
                                    
                                    ForecastView(time:"4 PM", celcius: 97, image: "sun.haze")
                                    
                                    ForecastView(time:"5 PM", celcius: 97, image: "sun.haze")
                                    
                                    ForecastView(time:"6 PM", celcius: 97, image: "sun.haze")
                                }
                            }
                        }
                        
                        WeatherDataView()
                        
                    }
                    .background {
                        
                        GeometryReader{ _ in
                            
                            SpriteView(scene: RainFallLanding(), options: [.allowsTransparency])
                                .offset(y: -10)
                        }
                        .offset(y: -(offset + topEdge) > 60 ? -(offset + (60 + topEdge)) : 0)
                        .opacity(showRain ? 1 : 0)
                        
                    }
                }
                .padding(.top, 25)
                .padding(.top, topEdge)
                .padding([.horizontal, .bottom])
                //getting offset
                .overlay(
                    overView()
                )
                
            }
        }
    }
    
    @ViewBuilder
    func overView() -> some View {
        
        GeometryReader { proxy -> Color in
            
            let minY = proxy.frame(in: .global).minY
            
            DispatchQueue.main.async {
                self.offset = minY
                print("++++++++++++++\(minY + topEdge)")
            }
            
            return Color.clear
        }
    }
    
    func getTitleOpactiy() -> CGFloat {
        
        let titleOffset = -getTitleOffset()
        
        let progress = titleOffset / 20
        
        let opacity = 1 - progress
        
        return opacity
    }
    
    func  getTitleOffset() -> CGFloat {
        
        //setting one max height for whole title...
        //consider max as 120...
        
        if offset < 0 {
            let progress = -offset / 120
            
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            
            return -newOffset
        }
        
        return 0
    }
}

@available(iOS 15.0, *)
struct WeatherAPPUI_Previews: PreviewProvider {
    static var previews: some View {
        WeatherAPPUI()
    }
}

@available(iOS 15.0, *)
struct ForecastView: View {
    
    var time: String
    var celcius: CGFloat
    var image: String
    
    var body: some View {
        VStack(spacing: 15) {
            
            
            Text(time)
                .font(.callout.bold())
                .foregroundStyle(.white)
            
            Image(systemName: image)
                .font(.title2)
            // multicolor
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .white)
                .frame(height: 30)
            
            Text("\(Int(celcius))°")
                .font(.callout.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
    }
}

// going to create Rain/Snow effect Like ios 15 weather app....
// sprite kit rain scene

class RainFall: SKScene {
    
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        //anchor point
        anchorPoint = CGPoint(x: 0.5, y: 1)
        
        //bg color
        backgroundColor = .clear
        
        // creating node and adding to scene...
        let node = SKEmitterNode(fileNamed: "RainFall.sks")!
        addChild(node)
        
        //full Width
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}

// next rain fall landing scene...
class RainFallLanding: SKScene {
    
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        let height = UIScreen.main.bounds.height
        //geting percentage by eminiationg postion range...
        //anchor point
        anchorPoint = CGPoint(x: 0.5, y: (height - 5) / height)
        
        
        
        //bg color
        backgroundColor = .clear
        
        // creating node and adding to scene...
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        
        //Romoved for card padding
        node.particlePositionRange.dx = UIScreen.main.bounds.width - 30
    }
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
