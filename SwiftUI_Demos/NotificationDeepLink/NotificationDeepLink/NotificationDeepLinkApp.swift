//
//  NotificationDeepLinkApp.swift
//  NotificationDeepLink
//
//  Created by Xiaofu666 on 2025/1/20.
//

import SwiftUI

@main
struct NotificationDeepLinkApp: App {
    @UIApplicationDelegateAdaptor(AppData.self) private var appData
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appData)
                .onOpenURL { url in
                    if let pageName = url.host() {
                        print(pageName)
                        appData.addPath(pageName)
                    }
                }
        }
    }
}

@Observable
class AppData: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var mainPageNavigationPath: [String] = []
    
    func addPath(_ path: String) {
        /// 如果想保留以前的页面，可以跳过此步骤
        mainPageNavigationPath = []
        mainPageNavigationPath.append(path)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response.notification.request.content.userInfo)
        if let pageLink = response.notification.request.content.userInfo["pageLink"] as? String {
            if !pageLink.contains("//") && mainPageNavigationPath.last != pageLink {
                /// 方式一
                addPath(pageLink)
            } else {
                /// 方式2
                guard let url = URL(string: pageLink) else { return }
                UIApplication.shared.open(url, options: [:]) { _ in
                    
                }
            }
        }
    }
}
