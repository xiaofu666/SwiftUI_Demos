//
//  AppData.swift
//  NetflixUI
//
//  Created by Lurich on 2024/4/13.
//

import SwiftUI

@Observable
class AppData {
    var isSplashFinished: Bool = false
    var activeTab: Tab = .home
    var hideMainView: Bool = false
    var tabProfileRect: CGRect = .zero
    var showProfileView: Bool = false
    var watchingProfile: Profile?
    var animateProfile: Bool = false
    var fromTabBar: Bool = false
}
