//
//  CustomFilteringDataView.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/6/10.
//

import SwiftUI

@available(iOS 15.0, *)
struct CustomFilteringDataView<Content: View>: View {
    var content: (SimpleTodoTask) -> Content
    @FetchRequest private var result: FetchedResults<SimpleTodoTask>
    
    init(displayPendingTask: Bool, filterDate: Date, content: @escaping (SimpleTodoTask) -> Content) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterDate)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay)!
        
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND isCompleted == %i", (startOfDay as NSDate), (endOfDay as NSDate), !displayPendingTask)
        
        _result = FetchRequest(entity: SimpleTodoTask.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SimpleTodoTask.date, ascending: false)], predicate: predicate, animation: .easeInOut(duration: 0.25))
        
        self.content = content
    }
    
    var body: some View {
        Group {
            if result.isEmpty {
                Text("No Task's Found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(result) {
                    content($0)
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct CustomFilteringDataView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleTodoView()
    }
}
