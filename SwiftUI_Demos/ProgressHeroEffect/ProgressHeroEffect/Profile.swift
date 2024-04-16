//
//  Profile.swift
//  ProgressHeroEffect
//
//  Created by Lurich on 2023/10/14.
//

import SwiftUI

/// Profile Model With Sample Data
struct Profile: Identifiable {
    var id = UUID()
    var userName: String
    var profilePicture: String
    var lastMsg:String
}
var profiles = [
    Profile(userName: "Jake",   profilePicture: "user1",  lastMsg: "Hi Swift UI !!!"),
    Profile(userName: "Jenna",  profilePicture: "user2",  lastMsg: "Nothing!"),
    Profile(userName: "Emily",  profilePicture: "user3",  lastMsg: "Binge Watching..."),
    Profile(userName: "Julie",  profilePicture: "user4",  lastMsg: "404 Page not Found!"),
    Profile(userName: "Misi",   profilePicture: "user5",  lastMsg: "Do not Disturb."),
    Profile(userName: "Swift",  profilePicture: "user6",  lastMsg: "You are good."),
]
