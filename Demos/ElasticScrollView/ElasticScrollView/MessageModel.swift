//
//  MessageModel.swift
//  ElasticScrollView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

//Message model...
struct MessageModel: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var name: String
    var message: String
    var onLine: Bool
    var read: Bool
}


var sampleMessages: [MessageModel] = [

    MessageModel(image: "Book 1", name: "Swift 简介", message: "Swift是一款易学易用的编程语言，而且它还是第一套具有与脚本语言同样的表现力和趣味性的系统编程语言。Swift的设计以安全为出发点，以避免各种常见的编程错误类别。", onLine: false, read: true),
    
    MessageModel(image: "Book 2", name: "Swift 介绍", message: "Swift是一种新的编程语言，用于编写iOS和macOS应用。Swift结合了C和Objective-C的优点并且不受C兼容性的限制。Swift采用安全的编程模式并添加了很多新特性，这将使编程更简单，更灵活，也更有趣。Swift是基于成熟而且倍受喜爱的Cocoa和Cocoa Touch框架，他的降临将重新定义软件开发。", onLine: false, read: true),
    
    MessageModel(image: "Book 3", name: "Objective-C 介绍", message: "Objective-C开发者对Swift并不会感到陌生。它采用了Objective-C的命名参数以及动态对象模型，可以无缝对接到现有的Cocoa框架，并且可以兼容Objective-C代码。在此基础之上，Swift还有许多新特性并且支持过程式编程和面向对象编程。", onLine: false, read: false),
    
    MessageModel(image: "Book 4", name: "Easy Payments with \nWalletory", message: "Swift 对于初学者来说也很友好。它是第一个既满足工业标准又像脚本语言一样充满表现力和趣味的编程语言。它支持代码预览，这个革命性的特性可以允许程序员在不编译和运行应用程序的前提下运行Swift代码并实时查看结果。", onLine: false, read: true),
    
    MessageModel(image: "Book 5", name: "Swift 很好", message: "Swift不需要引入头文件或写在main()内，也不需要在每一句加上分号(当然，若你保有使用某些其他语言的习惯，如Java、C等 加上分号结尾亦不会报错)。", onLine: true, read: false),
    
    MessageModel(image: "Book 1", name: "Swift 简介", message: "Swift是一款易学易用的编程语言，而且它还是第一套具有与脚本语言同样的表现力和趣味性的系统编程语言。Swift的设计以安全为出发点，以避免各种常见的编程错误类别。", onLine: false, read: true),
    
    MessageModel(image: "Book 2", name: "Swift 介绍", message: "Swift是一种新的编程语言，用于编写iOS和macOS应用。Swift结合了C和Objective-C的优点并且不受C兼容性的限制。Swift采用安全的编程模式并添加了很多新特性，这将使编程更简单，更灵活，也更有趣。Swift是基于成熟而且倍受喜爱的Cocoa和Cocoa Touch框架，他的降临将重新定义软件开发。", onLine: false, read: true),
    
    MessageModel(image: "Book 3", name: "Objective-C 介绍", message: "Objective-C开发者对Swift并不会感到陌生。它采用了Objective-C的命名参数以及动态对象模型，可以无缝对接到现有的Cocoa框架，并且可以兼容Objective-C代码。在此基础之上，Swift还有许多新特性并且支持过程式编程和面向对象编程。", onLine: false, read: false),
    
    MessageModel(image: "Book 4", name: "Easy Payments with \nWalletory", message: "Swift 对于初学者来说也很友好。它是第一个既满足工业标准又像脚本语言一样充满表现力和趣味的编程语言。它支持代码预览，这个革命性的特性可以允许程序员在不编译和运行应用程序的前提下运行Swift代码并实时查看结果。", onLine: false, read: true),
    
    MessageModel(image: "Book 5", name: "Swift 很好", message: "Swift不需要引入头文件或写在main()内，也不需要在每一句加上分号(当然，若你保有使用某些其他语言的习惯，如Java、C等 加上分号结尾亦不会报错)。", onLine: true, read: false),
    
]
