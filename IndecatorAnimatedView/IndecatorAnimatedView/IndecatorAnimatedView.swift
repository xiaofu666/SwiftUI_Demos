//
//  IndecatorAnimatedView.swift
//  IndecatorAnimated
//
//  Created by Lurich on 2021/8/30.
//

import SwiftUI

//intro model and simple intro's...
struct intro: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var color: Color
}

var intros : [intro] = [

    intro(image: "Book 1", title: "Choose your favourite menu", description: "But they are not the inconvience that our pleasure", color: Color("Blue")),
    intro(image: "Book 2", title: "Find the best price", description: "There is no provision to smooth the consequences are", color: Color("Yellow")),
    intro(image: "Book 3", title: "Your food is ready to be delivered", description: "ter than the plain of the soul to the task", color: Color("Pink")),

]

@available(iOS 15.0, *)
struct IndecatorAnimatedView: View {
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        VStack {
            OffsetPageTabView(offset: $offset) {
                
                HStack(spacing: 0) {
                    
                    ForEach(intros) {intro in
                        
                        VStack {
                            
                            Image(intro.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: getScreenRect().height / 3)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Text(intro.title)
                                    .font(.largeTitle.bold())
                                
                                Text(intro.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            .foregroundStyle(.white)
                            .padding(.top, 50)
                            .frame(maxWidth:.infinity, alignment: .leading)
                        }
                        .padding()
                        //setting max Width
                        .frame(width: getScreenRect().width)
                    }
                }
 
            }
            
            //animation indicator...
            HStack(alignment: .bottom) {
                
                //indicators...
                HStack(spacing:12) {
                    
                    ForEach(intros.indices, id: \.self) { index  in
                        
                        Capsule()
                            .fill(.white)
                        //increasing width for only current index...
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                            
                    }
                }
                .overlay(

                    Capsule()
                        .fill(.white)
                        .frame(width: 20, height: 7)
                        .offset(x: getIndicatorOffset())

                    ,alignment: .leading
                )
                .offset(x:10, y: -15)
                
                Spacer()
                
                Button {
                    
                    let index = min(getIndex() + 1, intros.count - 1)
                    
                    offset = CGFloat(index) * getScreenRect().width
                    
                } label: {
                
                    Image(systemName: "chevron.right")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(20)
                        .background(
                        
                            intros[getIndex()].color,
                            in: Circle()
                        )
                }

            }
            .padding()
            .offset(y: -20)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onChange(of: offset) { _ in
            
//            print(offset)
        }
        //animating when index changes...
        .animation(.easeInOut, value: getIndex())
    }
    
    //offset for indicator...
    func getIndicatorOffset() -> CGFloat {
        
        let progress = offset / getScreenRect().width
        
        //12 = spacing
        //7 = circleSize
        let maxWidth: CGFloat = 12 + 7
        
        return progress * maxWidth
    }
    
    //Expading index based on offset...
    func getIndex() -> Int {
        
        let progress = round(offset / getScreenRect().width)
        
        //for saftey
        let index = min(Int(progress), intros.count - 1)
        return index
    }
}

@available(iOS 15.0, *)
struct IndecatorAnimatedView_Previews: PreviewProvider {
    static var previews: some View {
        IndecatorAnimatedView()
            .preferredColorScheme(.dark)
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
}
