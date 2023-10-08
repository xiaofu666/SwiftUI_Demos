//
//  intro.swift
//  IntroView
//
//  Created by Lurich on 2023/9/18.
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

var dummyText = "Swift，苹果于2014年WWDC苹果开发者大会发布的新开发语言，可与Objective-C共同运行于macOS和iOS平台，用于搭建基于苹果平台的应用程序。Swift是一款易学易用的编程语言，而且它还是第一套具有与脚本语言同样的表现力和趣味性的系统编程语言。Swift的设计以安全为出发点，以避免各种常见的编程错误类别。 [1]2015年12月4日，苹果公司宣布其Swift编程语言开放源代码。长600多页的The Swift Programming Language [2]  可以在线免费下载。"

