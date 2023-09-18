//
//  View++.swift
//  SpotLightView
//
//  Created by Lurich on 2023/9/18.
//

import SwiftUI

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

//MARK: ROOT View Controller
func getWindow() -> UIWindow {
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return .init()
    }
    guard let window = screen.windows.first else {
        return .init()
    }
    return window
}

//MARK: ROOT View Controller
func getRootController() -> UIViewController {
    guard let root = getWindow().rootViewController else {
        return .init()
    }
    return root
}

//MARK: Top View Controller
func getTopController() -> UIViewController {
    var resultVC = getRootController()
    func topViewController(_ vc: UIViewController) -> UIViewController {
        if let tmpVC = vc as? UINavigationController {
            return topViewController(tmpVC.topViewController!)
        } else if let tmpVC = vc as? UITabBarController {
            return topViewController(tmpVC.selectedViewController!)
        } else {
            return vc
        }
    }
    while resultVC.presentedViewController != nil {
        resultVC = topViewController(resultVC.presentedViewController!)
    }
    return resultVC
}
