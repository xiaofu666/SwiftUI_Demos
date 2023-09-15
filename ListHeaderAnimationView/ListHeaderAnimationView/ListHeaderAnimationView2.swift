//
//  ListHeaderAnimationView2.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/30.
//

import SwiftUI


struct ListHeaderAnimationView2: View {
    
    var plot = "拥有财富、名声、权力，这世界上的一切的男人 “海贼王”哥尔·D·罗杰，在被行刑受死之前说了一句话，让全世界的人都涌向了大海。“想要我的宝藏吗？如果想要的话，那就到海上去找吧，我全部都放在那里。”，世界开始迎接“大海贼时代”的来临 。\n时值“大海贼时代”，为了寻找传说中海贼王罗杰所留下的大秘宝“ONE PIECE”，无数海贼扬起旗帜，互相争斗。有一个梦想成为海贼王的少年叫路飞，他因误食“恶魔果实”而成为了橡皮人，在获得超人能力的同时付出了一辈子无法游泳的代价。十年后，路飞为实现与因救他而断臂的香克斯的约定而出海，他在旅途中不断寻找志同道合的伙伴，开始了以成为海贼王为目标的冒险旅程 "
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            
            GeometryReader(content: { geometry in
                
                if geometry.frame(in: .global).minY >  -480 {
                    
                    Image("onePiece")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -geometry.frame(in: .global).minY)
                        .frame(height: geometry.frame(in: .global).minY > 0 ? geometry.frame(in: .global).minY + 480 : 480)
                        .frame(minWidth: UIScreen.main.bounds.width)
                }
                
            })
            .scaledToFill()
            .frame(height:480)
            
            VStack(alignment: .leading, spacing: 15, content: {
                Text("OnePiece")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                
                
                HStack {
                    
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index < 5 ? .yellow : .white)
                    }
                    
                }
                
                Text("1997年日本漫画家尾田荣一郎创作的少年漫画")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    
                Text(plot)
                    .padding(.top, 10)
                    .foregroundColor(.white)
                
                HStack(spacing:15) {
                    
                    Button(action: {}, label: {
                        Text("Bookmark")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Text("Buy Tickes")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .background(Color.red)
                            .cornerRadius(10)
                    })
                    
                    
                }
                
            })
            .frame(width: UIScreen.main.bounds.width - 20)
            .padding(.vertical, 25)
            .padding(.horizontal)
            .background(Color.black)
            .cornerRadius(20)
            .offset(y: -35)
           
            
            
            
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        
    }
    
}


struct ListHeaderAnimationView2_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderAnimationView2()
    }
}
