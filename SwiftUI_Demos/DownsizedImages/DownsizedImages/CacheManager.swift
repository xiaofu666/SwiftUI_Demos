//
//  CacheManager.swift
//  DownsizedImages
//
//  Created by Xiaofu666 on 2025/1/7.
//

import SwiftUI
import SwiftData

@Model
class Cache {
    var cacheID: String
    var data: Data
    var expiration: Date
    var creation: Date = Date()
    
    init(cacheID: String, data: Data, expiration: Date) {
        self.cacheID = cacheID
        self.data = data
        self.expiration = expiration
    }
}

final class CacheManager {
    @MainActor static let shared = CacheManager()
    let context: ModelContext? = {
        guard let container = try? ModelContainer(for: Cache.self) else { return nil }
        let context = ModelContext(container)
        return context
    }()
    let cacheLimit: Int = 30
    init() {
        removeExpiredItems()
    }
    
    private func removeExpiredItems() {
        guard let context else { return }
        let todayDate: Date = .now
        let predicate = #Predicate<Cache> { todayDate > $0.expiration }
        let descriptor = FetchDescriptor(predicate: predicate)
        do {
            try context.enumerate(descriptor) { model in
                context.delete(model)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func verifyLimits() throws {
        guard let context else { return }
        let countDescriptor = FetchDescriptor<Cache>()
        let count = try context.fetchCount(countDescriptor)
        if count >= cacheLimit {
            var fetchDescriptor = FetchDescriptor<Cache>(sortBy: [.init(\.creation, order: .forward)])
            fetchDescriptor.fetchLimit = 1
            if let oldCache = try context.fetch(fetchDescriptor).first {
                context.delete(oldCache)
            }
        }
    }
    
    private func calculateExpirationDate(_ days: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: days, to: .now) ?? .now
    }
    /// CRUD
    func insert(id: String, data: Data, expirationDays: Int) throws {
        guard let context else { return }
        if let cache = try get(id: id) {
            context.delete(cache)
        }
        try verifyLimits()
        let expiration = calculateExpirationDate(expirationDays)
        let cache = Cache(cacheID: id, data: data, expiration: expiration)
        context.insert(cache)
        try context.save()
    }
    func get(id: String) throws -> Cache? {
        guard let context else { return nil }
        let predicate = #Predicate<Cache> { $0.cacheID == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        if let cache = try context.fetch(descriptor).first {
            return cache
        }
        return nil
    }
    func remove(id: String) throws {
        guard let context else { return }
        if let cache = try get(id: id) {
            context.delete(cache)
            try context.save()
        }
    }
    func removeAll() throws {
        guard let context else { return }
        let descriptor = FetchDescriptor<Cache>()
        try context.enumerate(descriptor) {
            context.delete($0)
        }
        try context.save()
    }
}

#Preview {
    ContentView()
}
