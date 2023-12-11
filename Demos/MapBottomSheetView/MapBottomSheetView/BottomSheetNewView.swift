//
//  Home.swift
//  BottomSheetNew
//
//  Created by Lurich on 2021/6/11.
//

import SwiftUI

struct BottomSheetNewView: View {
    
    // search text binding value
    @State var searchText = ""
    
    //gesture properties...
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    var body: some View {
    
        ZStack  {
            
            // for getting franme for image...
            GeometryReader { proxy in
                
                let frame = proxy.frame(in: .global)
                
                Image("xiaoma")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
                    
                    
            }
            .blur(radius: getBlurRadius())
            .ignoresSafeArea()
            
            //bottom sheet...
            
            //for getting height for drag gesture
            GeometryReader {proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                return AnyView (
                    
                    ZStack {
                        
                        BlurEffect(style: .systemThinMaterialDark)
                            .clipShape(ClipCornerShape(corners: [.topLeft, .topRight], radius: 30))
                        
                        VStack {
                            
                            VStack {
                               
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 4)
                                
                                
                                TextField("Search", text: $searchText)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(BlurEffect(style: .dark))
                                    .cornerRadius(10)
                                    .colorScheme(.dark)
                                    .padding(.top, 10)
                            }
                            .frame(height: 100)
                            
                            
                            
                            //bottom content
                            ScrollView(.vertical, showsIndicators: false, content: {
                                
                                BottomContent()
                            })
                        }
                        .padding(.horizontal)
                        .frame(maxHeight:.infinity, alignment: .top)
                        
                    }
                    .offset(y: height - 100)
                    .offset(y: -offset > 0 ?  -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        
                        out = value.translation.height
                        onChange()
                        
                    }).onEnded({ value in
                        
                        let maxHeight = height - 100
                        withAnimation {
                            
                            // logic conditions for moving states..
                            // up down or mmid...
                            if -offset > 10 && -offset < maxHeight / 2 {
                                
                                // mid...
                                offset = (-maxHeight / 3)
                            } else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            } else {
                                offset = 0
                            }
                            
                        }
                        
                        // store last offset
                        // so that gestrue can contiue from last position
                        lastOffset = offset
                        
                    }))
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func onChange() {
        
        DispatchQueue.main.async {
            
            self.offset = gestureOffset + lastOffset
        }
    }
    
    //blur radius for bg...
    func getBlurRadius() ->  CGFloat {
       
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        
        return progress * 30
    }
}


struct BottomSheetNewView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetNewView()
    }
}


struct BottomContent: View {
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("Favorites")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}, label: {
                    Text("See All")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                })
            }
            .padding(.top, 20)
            
            Divider()
                .background(Color.white)
            
            ScrollView (.horizontal, showsIndicators: false, content: {
                
                HStack(spacing: 15) {
                    
                    VStack (spacing: 8){
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "house.fill")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurEffect(style: .dark))
                                .clipShape(Circle())
                            
                        })
                        
                        Text("Home")
                            .foregroundColor(.white)
                        
                    }
                    
                    VStack (spacing: 8){
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "briefcase.fill")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurEffect(style: .dark))
                                .clipShape(Circle())
                            
                        })
                        
                        Text("Work")
                            .foregroundColor(.white)
                        
                    }
                    
                    VStack (spacing: 8){
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "plus")
                                .font(.title)
                                .frame(width: 65, height: 65)
                                .background(BlurEffect(style: .dark))
                                .clipShape(Circle())
                            
                        })
                        
                        Text("Add")
                            .foregroundColor(.white)
                        
                    }
                }
            })
            .padding(.top)
            
            HStack {
                
                Text("Editor's Pick")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}, label: {
                    Text("See All")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                })
            }
            .padding(.top, 20)
            
            Divider()
                .background(Color.white)
            
            ForEach(1...6, id:\.self) { index in
                
                Image("user\(index)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 250, alignment: .center)
                    .cornerRadius(15)
                    .padding(.top, 10)
            }
            
        }
    }
}
