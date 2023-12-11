//
//  Home.swift
//  LikedAnimation0906
//
//  Created by Lurich on 2021/9/6.
//

import SwiftUI

struct Post: Identifiable, Hashable {
    
    var id = UUID().uuidString
    var imageName: String
    var isLiked: Bool = false
    var title: String = ""
    var description: String = ""
    var starRating: Int = 0
    var width: Double = 160
    var height: Double = 90
}

@available(iOS 14.0, *)
struct LikeHome: View {
    
    //Sample Posts...
    @State var posts: [Post] = [
        
        Post(imageName: "user1"),
        Post(imageName: "user2"),
        Post(imageName: "user3"),
        Post(imageName: "user4"),
        Post(imageName: "user5"),
        Post(imageName: "user6"),
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(posts) { post in
                    VStack(alignment: .leading, spacing: 12) {
                        GeometryReader { proxy in
                            Image(post.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(15)
                        }
                        .frame(height: 280)
                        //adding overlay...
                        .overlay (
                            HeartLike(isTapped: $posts[getIndex(post: post)].isLiked, taps: 2)
                        )
                        .cornerRadius(15)
                        
                        Button {
                            posts[getIndex(post: post)].isLiked.toggle()
                        } label: {
                            Image(systemName: post.isLiked ? "suit.heart.fill" : "suit.heart")
                                .font(.title2)
                                .foregroundColor(post.isLiked ? .red : .gray)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Heart Animation")
    }
    
    // getting index ....
    func getIndex(post: Post) -> Int {
        let index = posts.firstIndex { currentPost in
            return currentPost.id == post.id
        } ?? 0
        return index
    }
}

@available(iOS 14.0, *)
struct LikeHome_Previews: PreviewProvider {
    static var previews: some View {
        LikeHome()
    }
}


// custom shape
// for resetting from center...
struct CustomLikeShape: Shape {
    
    //value ...
    var radius: CGFloat
    
    //animating path...
    var animatableData: CGFloat {

        get {return radius}
        set {radius = newValue}
    }
    
    //animatable path wont work on preview
    
    func path(in rect: CGRect) -> Path {
        
        return Path {path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            // adding center circle...
            let  center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            path.move(to: center)
            path.addArc(center: center, radius: radius,  startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
        }
    }
}
