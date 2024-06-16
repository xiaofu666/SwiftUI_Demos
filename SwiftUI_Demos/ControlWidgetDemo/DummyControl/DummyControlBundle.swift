//
//  DummyControlBundle.swift
//  DummyControl
//
//  Created by Lurich on 2024/6/16.
//

import WidgetKit
import SwiftUI

@main
struct DummyControlBundle: WidgetBundle {
    var body: some Widget {
        DummyControl()
        DummyControlControl()
        DummyControlControl2()
    }
}
