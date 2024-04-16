//
//  DynamicFilteredView.swift
//  TaskManager0505
//
//  Created by Lurich on 2022/5/6.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)
            
            let filterKey = "deadline"

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow as Any, 0])
            
        } else if currentTab == "Upcoming" {
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            let filterKey = "deadline"

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
            
        } else if currentTab == "Failed" {
            
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            let filterKey = "deadline"

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
            
        }else {
            
            let today = calendar.startOfDay(for: Date())
            let tommorow = Date.distantFuture
            
            let filterKey = "deadline"

            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 1])
        }
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \TaskData.deadline, ascending: false)], predicate: predicate, animation: .easeInOut)
        self.content = content
    }
    
    var body: some View {
        
        Group {
            
            if request.isEmpty {
                
                Text("No tasks found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                
                ForEach(request,  id: \.objectID) { object in
                    
                    self.content(object)
                }
            }
        }
    }
}


