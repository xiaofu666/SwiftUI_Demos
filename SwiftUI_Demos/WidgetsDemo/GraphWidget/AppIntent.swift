//
//  AppIntent.swift
//  GraphWidget
//
//  Created by Lurich on 2023/12/11.
//

import WidgetKit
import AppIntents
import SwiftUI

struct TabButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "Tab Button Intent"
    
    @Parameter(title: "App ID", default: "")
    
    var appID: String
    
    init(appID: String) {
        self.appID = appID
    }
    
    init() {
        
    }
    
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue(appID, forKey: "selectedApp")
        return .result()
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Line Chart", default: false)
    var isLineChart: Bool
    
    @Parameter(title: "Chart Tint", query: ChartTintQuery())
    var chartTint: ChartTint?
}

struct ChartTint: AppEntity {
    var id: UUID = .init()
    var name: String
    var color: Color
    
    static var defaultQuery = ChartTintQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Chart Tint"
    var displayRepresentation: DisplayRepresentation {
        return .init(title: "\(name)")
    }
}

struct ChartTintQuery: EntityQuery {
    func entities(for identifiers: [ChartTint.ID]) async throws -> [ChartTint] {
        return chartTints.filter { tint in
            identifiers.contains { uuid in
                tint.id == uuid
            }
        }
    }
    
    func suggestedEntities() async throws -> [ChartTint] {
        return chartTints
    }
    
    func defaultResult() async -> ChartTint? {
        return chartTints.first
    }
}

var chartTints: [ChartTint] = [
    .init(name: "Red", color: .red),
    .init(name: "Orange", color: .orange),
    .init(name: "Yellow", color: .yellow),
    .init(name: "Green", color: .green),
    .init(name: "Cyan", color: .cyan),
    .init(name: "Blue", color: .blue),
    .init(name: "Purple", color: .purple),
]
