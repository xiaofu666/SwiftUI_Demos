//
//  Profile.swift
//  HeroNavigationStack
//
//  Created by Xiaofu666 on 2024/11/18.
//

import SwiftUI

struct Profile:Identifiable,Hashable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
}

/// Sample Profile Data
var profiles = [
    Profile(userName: "Xiaofu", profilePicture: "Profile 1", lastMsg: "Hi Xiaofu !!!"),
    Profile(userName: "Jenna Ezarik", profilePicture: "Profile 2", lastMsg: "Nothing!"),
    Profile(userName: "Emily", profilePicture: "Profile 3", lastMsg: "Binge Watching"),
    Profile(userName: "Julie", profilePicture: "Profile 4", lastMsg: "404 Page not Found"),
    Profile(userName: "Kaviya", profilePicture: "Profile 5", lastMsg: "Do not Disturb.")
]
