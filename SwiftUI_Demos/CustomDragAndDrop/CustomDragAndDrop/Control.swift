//
//  Control.swift
//  CustomDragAndDrop
//
//  Created by Xiaofu666 on 2024/9/2.
//

import SwiftUI

struct Control: Identifiable, Hashable {
    var id: UUID = .init()
    var symbol: String = ""
    var title: String
    var frame: CGRect = .zero
}

var controlList: [Control] = [
    .init(symbol: "airplane", title: "Airplane Mode"),
    .init(symbol: "wifi", title: "Wifi"),
    .init(symbol: "cellularbars", title: "Cellular Data"),
    .init(symbol: "personalhotspot", title: "Personal Hotspot"),
    .init(symbol: "flashlight.off.fill", title: "Flashlight"),
    .init(symbol: "square.on.square", title: "Screen Mirror"),
    .init(symbol: "lock.rotation", title: "Device Orientation"),
    .init(symbol: "moonphase.last.quarter", title: "Dark Mode"),
    .init(symbol: "battery.50percent", title: "Low Power Mode"),
    .init(symbol: "record.circle", title: "Screen Record"),
    .init(symbol: "qrcode.viewfinder", title: "QR Scanner"),
    .init(symbol: "shazam.logo", title: "Shazam"),
    .init(symbol: "timer", title: "Timer"),
    .init(symbol: "stopwatch", title: "Stopwatch"),
    .init(symbol: "camera.fill", title: "Camera")
]
