//
//  AppModel.swift
//  WidgetsDemo
//
//  Created by Lurich on 2023/12/11.
//

import SwiftUI

struct AppModel: Identifiable {
    var id: String
    var appName: String
    var appDownloads:[Downloads]
}
let apps: [AppModel] = [
    .init(id: "App 1", appName: "App 1 Name", appDownloads: appDownloads),
    .init(id: "App 2", appName: "App 2 Name", appDownloads: appDownloads1),
    .init(id: "App 3", appName: "App 3 Name", appDownloads: appDownloads2),
]
