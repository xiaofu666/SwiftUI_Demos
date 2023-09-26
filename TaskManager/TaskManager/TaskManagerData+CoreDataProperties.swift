//
//  TaskManagerData+CoreDataProperties.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/2.
//
//

import Foundation
import CoreData


extension TaskManagerData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskManagerData> {
        return NSFetchRequest<TaskManagerData>(entityName: "TaskManagerData")
    }

    @NSManaged public var dateAdded: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var taskName: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskCategory: String?

}

extension TaskManagerData : Identifiable {

}
