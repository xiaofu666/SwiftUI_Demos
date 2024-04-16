//
//  DynamicNotificationViewApp.swift
//  DynamicNotificationView
//
//  Created by Lurich on 2023/9/19.
//

import SwiftUI

@main
struct DynamicNotificationViewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appdelegate
    @State var notifications: [NotificationValue] = []
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .top) {
                    GeometryReader { proxy in
                        ForEach (notifications) { notificationValue in
                            NotificationPreview(size: proxy.size, value: notificationValue, notifications: $notifications)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .ignoresSafeArea()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("DynamicIsland"))) { output in
                    if let content = output.userInfo?["content"] as? UNNotificationContent {
                        notifications.append(NotificationValue(content: content))
                    }
                }
        }
    }
}

@available(iOS 15.0, *)
struct NotificationPreview: View {
    var size: CGSize
    var value: NotificationValue
    @Binding var notifications: [NotificationValue]
    var body: some View {
        HStack {
            if let image = UIImage(named: "AppIcon60x60") {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                if value.content.title.count > 0 {
                    Text(value.content.title)
                        .font(.title2)
//                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                if value.content.subtitle.count > 0 {
                    Text(value.content.subtitle)
                        .font(.title3)
    //                    .fontWeight(.light)
                        .foregroundColor(.white)
                }
                
                if value.content.body.count > 0 {
                    Text(value.content.body)
                        .font(.caption)
    //                    .fontWeight(.light)
                        .foregroundColor(.gray)
                }
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .scaleEffect(value.showNotifacation ? 1.0 : 0.5, anchor: .top)
        .opacity(value.showNotifacation ? 1 : 0)
        .blur(radius: value.showNotifacation ? 0 : 30)
        .frame(width: value.showNotifacation ? size.width - 22 : 126, height: value.showNotifacation ? 100 : 37.33)
        .background {
            // 126 / 2 = 63
            RoundedRectangle(cornerRadius: value.showNotifacation ? 50 : 63)
                .fill(.black)
        }
        .clipped()
        .offset(y: 11)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: value.showNotifacation)
        .onChange(of: value.showNotifacation, perform: { newValue in
            if newValue && notifications.indices.contains(index) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if notifications.indices.contains(index + 1) {
                        notifications[index + 1].showNotifacation = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        notifications[index].showNotifacation = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if notifications.indices.contains(index + 1) {
                                notifications[index + 1].showNotifacation = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            notifications.remove(at: index)
                        }
                    }
                }
            }
        })
        .onAppear() {
            if index == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    notifications[index].showNotifacation = true
                }
            }
        }
    }
    var index: Int {
        return notifications.firstIndex{ cValue in
            cValue.id == value.id
        } ?? 0
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if UIApplication.shared.haveDynamicIsland {
            print("有灵动岛")
            NotificationCenter.default.post(name: Notification.Name("DynamicIsland"), object: nil, userInfo: ["content": notification.request.content])
            return [.sound]
        } else {
            print("没有灵动岛")
            return [.sound, .banner]
        }
    }
}

extension UIApplication {
    var haveDynamicIsland: Bool {
        var isHave = false
        if #available(iOS 16.0, *), let window = getCurrentWindow() {
            isHave = window.safeAreaInsets.top >= 51
        }
        return isHave
    }
    func getCurrentWindow() -> UIWindow? {
        // 获取应用程序所有窗口场景
        let scenes = UIApplication.shared.connectedScenes

        // 遍历所有窗口场景，找到主窗口场景
        for scene in scenes {
            if scene is UIWindowScene {
                let windowScene = scene as! UIWindowScene
                return windowScene.windows.first { $0.isKeyWindow }
            }
        }

        // 未找到主窗口
        return nil
    }
}

