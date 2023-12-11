//
//  WebView.swift
//  GoogleWebTabView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: URL
    func makeUIView(context: Context) -> WKWebView{
        
        let view = WKWebView()
        view.load(URLRequest(url: url))
        view.isUserInteractionEnabled = false
        
        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

