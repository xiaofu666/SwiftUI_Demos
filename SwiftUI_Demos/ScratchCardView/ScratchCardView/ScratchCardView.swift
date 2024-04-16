//
//  ScratchCardView.swift
//  ScratchCardView
//
//  Created by Lurich on 2023/9/15.
//

import SwiftUI

struct ScratchCardHomeView: View {
    
    @State var onFinish: Bool = false
    
    var body: some View {
        
        VStack {
            
            // CardView
            ScratchCardView (cursorSize: 50, onFinish: $onFinish){
                
                // body content
                VStack {
                    
                    Image("Food")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(10)
                        .frame(width: 150, height: 150)
                    
                    Text("You've Won")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Text("$199.78")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                
                
            } overlayView: {
                
                //overlay Image Or View
                Image("Pic")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                
            }

            
        }
        //to avoid Spacers
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .overlay(
            
            HStack(spacing: 15) {
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            
                Text("Scrath Card")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                
                Spacer(minLength: 0)
            
                Button {
                    
                    onFinish = false
                    
                } label: {
                    
                    Image("Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                }


            }
                .padding(.horizontal, 20)
            
            
            ,alignment: .top
        )
    }
}

struct ScratchCardHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardHomeView()
    }
}

// CustomView
// Using View Builder...

struct ScratchCardView<Content: View, OverlayView: View>: View {
    
    
    var content: Content
    var overlayView: OverlayView
    
    init(cursorSize:CGFloat, onFinish: Binding<Bool>, @ViewBuilder content: @escaping ()-> Content, @ViewBuilder overlayView: @escaping ()-> OverlayView) {
        
        self.content = content()
        self.overlayView = overlayView()
        self.cursorSize = cursorSize
        self._onFinish = onFinish
    }
    
    // For scratch Effect....
    @State var startingPoint: CGPoint = .zero
    @State var points:[CGPoint] = []
    
    //for gesture updates..
    @GestureState var gestrreLocation: CGPoint = .zero
    
    // Customisation adn on finish
    var cursorSize: CGFloat
    @Binding var onFinish: Bool
    
    var body: some View {
        
        
        ZStack {
            
            overlayView
                .opacity(onFinish ? 0 : 1)
            
            // logic is when user starts scratching the main conten will starts visible
            // based on the user drag location....
            // add show full content when the user release the drag...
            content
                .mask(
                    
                    ZStack {
                        if  !onFinish {
                            ScratchMask(points: points, startingPoint: startingPoint)
                                .stroke(style: StrokeStyle(lineWidth: cursorSize, lineCap: .round, lineJoin: .round))
                        }
                        else  {
                            
                            // show Full conten...
                            Rectangle()
                        }
                    }
                )
                .gesture(
                    
                    DragGesture()
                        .updating($gestrreLocation, body: { value, out, _ in
                    
                            out = value.location
                            DispatchQueue.main.async {
                                // Updating starting Point...
                                // and adding user drag locations
                                if startingPoint == .zero {
                                    startingPoint = value.location
                                }
                                points.append(value.location)
                            }
                        })
                        .onEnded({ value in
                            if points.count > 100 {
                                withAnimation {
                                    onFinish = true
                                }
                            }
                        })
                )
        }
        .frame(width: 300, height: 300)
        .cornerRadius(20)
        .onChange(of: onFinish) { newValue in
            //checking and reseting View...
            if !onFinish  && !points.isEmpty {
                withAnimation(.easeInOut) {
                    resetView()
                }
            }
        }
    }
    
    func resetView() {
        points.removeAll()
        startingPoint = .zero
    }
    
}

    
    
// Scratch Mask Shape...
// it will appear based on user gesture...
struct ScratchMask: Shape {
    
    var points: [CGPoint]
    var startingPoint: CGPoint
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            path.move(to: startingPoint)
            path.addLines(points)
        }
    }
}

