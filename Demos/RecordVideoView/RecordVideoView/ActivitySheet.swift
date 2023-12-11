//
//  ActivitySheet.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/19.
//

import SwiftUI

struct ActivitySheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return activity
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}

struct CoreDataShareSheet: UIViewControllerRepresentable {
    @Binding var url: URL
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
