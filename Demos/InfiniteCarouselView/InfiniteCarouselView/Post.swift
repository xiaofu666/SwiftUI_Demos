//
//  Post.swift
//  InfiniteCarouselView
//
//  Created by Lurich on 2023/9/19.
//

import SwiftUI

//Post model...
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


var posts = [

    Post(imageName: "Book 1", title: "Swift 简介", description: "Swift是一款易学易用的编程语言，而且它还是第一套具有与脚本语言同样的表现力和趣味性的系统编程语言。Swift的设计以安全为出发点，以避免各种常见的编程错误类别。", starRating: 4, width: 1080, height: 1920),
    
    Post(imageName: "Book 2", title: "Swift 介绍", description: "Swift是一种新的编程语言，用于编写iOS和macOS应用。Swift结合了C和Objective-C的优点并且不受C兼容性的限制。Swift采用安全的编程模式并添加了很多新特性，这将使编程更简单，更灵活，也更有趣。Swift是基于成熟而且倍受喜爱的Cocoa和Cocoa Touch框架，他的降临将重新定义软件开发。", starRating: 3, width: 1080, height: 1920),
    
    Post(imageName: "Book 3", title: "Objective-C 介绍", description: "Objective-C开发者对Swift并不会感到陌生。它采用了Objective-C的命名参数以及动态对象模型，可以无缝对接到现有的Cocoa框架，并且可以兼容Objective-C代码。在此基础之上，Swift还有许多新特性并且支持过程式编程和面向对象编程。", starRating: 5, width: 1080, height: 1920),
    
    Post(imageName: "Book 4", title: "Easy Payments with \nWalletory", description: "Swift 对于初学者来说也很友好。它是第一个既满足工业标准又像脚本语言一样充满表现力和趣味的编程语言。它支持代码预览，这个革命性的特性可以允许程序员在不编译和运行应用程序的前提下运行Swift代码并实时查看结果。", starRating: 3, width: 1080, height: 1920),
    
    Post(imageName: "Book 5", title: "Swift 很好", description: "Swift不需要引入头文件或写在main()内，也不需要在每一句加上分号(当然，若你保有使用某些其他语言的习惯，如Java、C等 加上分号结尾亦不会报错)。", starRating: 2, width: 1080, height: 1920),
    
]


struct PostCardView: View {
    
    var post: Post
    var body: some View {
        
        Image(post.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
