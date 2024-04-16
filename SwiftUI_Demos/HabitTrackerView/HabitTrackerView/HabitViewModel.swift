//
//  HabitViewModel.swift
//  HabitTracker0511
//
//  Created by Lurich on 2022/5/11.
//

import SwiftUI
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    
    @Published var addNewHabit: Bool = false
    
    @Published var title: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isReaminderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remiainderDate: Date = Date()
    
    @Published var showTimePicker: Bool = false
    
    @Published var editHabit: HabitData?
    
    @Published var notificationAccess: Bool = false
    
    init() {
        requestNotificationAccess()
    }
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    func addHabit(context: NSManagedObjectContext) async -> Bool {
        
        var habit: HabitData!
        if let editHabit = editHabit {
            habit = editHabit
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notificationIDs ?? [])
        } else {
            habit = HabitData(context: context)
        }
        
        habit.title = title
        habit.color = habitColor
        habit.weekDays = weekDays
        habit.isRemainderOn = isReaminderOn
        habit.remainderText = remainderText
        habit.notificationDate = remiainderDate
        habit.notificationIDs = []
        
        if isReaminderOn {
            //添加通知
            if let ids = try? await scheduleNotification() {
                habit.notificationIDs = ids
                if let _ = try? context.save() {
                    return true
                }
            }
        } else {
            if let _ = try? context.save() {
                return true
            }
            
        }
        return false
    }
    
    func scheduleNotification() async throws -> [String]{
        let content = UNMutableNotificationContent()
        content.title = "Habit Remainder"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        for weekDay in weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remiainderDate)
            let min = calendar.component(.minute, from: remiainderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay
            } ?? -1
            
            if day != -1 {
                var components = DateComponents()
                components.hour = hour
                components.minute = min
                //每周天数状态1-7
                components.weekday = day + 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
                notificationIDs.append(id)
            }
        }
        
        return notificationIDs
    }
    
    func resetData() {
        title = ""
        habitColor = "Card-1"
        weekDays = []
        isReaminderOn = false
        remiainderDate = Date()
        remainderText = ""
        editHabit = nil
    }
    
    func deleteHabit(context: NSManagedObjectContext) -> Bool{
        if let editHabit = editHabit {
            if editHabit.isRemainderOn {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notificationIDs ?? [])
            }
            context.delete(editHabit)
            if let _ = try?  context.save() {
                return true
            }
        }
        return false
    }
    
    func restoreEditData() {
        if let editHabit = editHabit {
            title = editHabit.title ?? ""
            habitColor = editHabit.color ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            isReaminderOn = editHabit.isRemainderOn
            remiainderDate = editHabit.notificationDate ?? Date()
            remainderText = editHabit.remainderText ?? ""
        }
    }
    
    
    func  doneStatus() -> Bool {
        let remainderStatus = isReaminderOn ? remainderText == "" : false
        
        if title == "" || weekDays.isEmpty || remainderStatus {
            return false
        }
        return true
    }
}

@objc(NSStringValueTransformer)
final class StringValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    // 定义静态属性name，方便使用
    static let name = NSValueTransformerName(rawValue: String(describing: StringValueTransformer.self))
    
    // 重写allowedTopLevelClasses，确保UIColor在允许的类列表中
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSString.self] // NSArray.self 也要加上，不然不能在数组中使用！
    }
    
    // 定义Transformer转换器注册方法
    public static func register() {
        let transformer = StringValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
