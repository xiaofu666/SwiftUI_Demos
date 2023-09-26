//
//  TaskManagerData+CoreDataClass.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/4/2.
//
//

import Foundation
import CoreData

@objc(TaskManagerData)
public class TaskManagerData: NSManagedObject, Codable {
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.contextKey] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        dateAdded = try values.decode(Date.self, forKey: .dateAdded)
        taskName = try values.decode(String.self, forKey: .taskName)
        taskDescription = try values.decode(String.self, forKey: .taskDescription)
        taskCategory = try values.decode(String.self, forKey: .taskCategory)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(id, forKey: .id)
        try values.encode(dateAdded, forKey: .dateAdded)
        try values.encode(taskName, forKey: .taskName)
        try values.encode(taskDescription, forKey: .taskDescription)
        try values.encode(taskCategory, forKey: .taskCategory)
    }
    
    enum CodingKeys: CodingKey {
        case id, dateAdded, taskName, taskDescription, taskCategory
    }
}

extension CodingUserInfoKey {
    static let contextKey = CodingUserInfoKey(rawValue: "managerObjectContext")!
}

enum ContextError: Error {
    case NoContextFound
}
