//
//  DynamicNotificationView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/3/18.
//

import SwiftUI

@available(iOS 16.0, *)
struct DynamicNotificationView: View {
    var body: some View {
        Text("In App Notifications \n Using Dynamic Island")
            .font(.title)
            .fontWeight(.semibold)
            .lineSpacing(12)
            .kerning(1.1)
            .multilineTextAlignment(.center)
            .onAppear(perform: authorizeNotifications)
            .padding()
        
        Text("手动创建一个通知")
            .onTapGesture {
                createNotofocation()
            }
    }
    
    func createNotofocation(){
        
        let content = UNMutableNotificationContent()
        content.title = "Me"
        content.subtitle = "Notification From In-App"
        content.body = "Notification Body"
        //assigning to our notification....
        content.categoryIdentifier = "ACTIONS"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requset = UNNotificationRequest(identifier: "IN-App", content: content, trigger: trigger)
        
        
        //actions....
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(requset, withCompletionHandler: nil)
    }
    
    func authorizeNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { bool, error in
            print("bool = \(bool)")
            if let error = error {
                print(error)
            }
        }
    }
}

@available(iOS 16.0, *)
struct DynamicNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicNotificationView()
    }
}
