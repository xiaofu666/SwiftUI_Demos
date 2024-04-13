//
//  Profile.swift
//  NetflixUI
//
//  Created by Lurich on 2024/4/13.
//

import SwiftUI

struct Profile: Identifiable {
    var id: UUID = .init()
    var name: String
    var icon: String
    
    var sourceAnchorID: String {
        return id.uuidString + "SOURCE"
    }
    
    var destinationAnchorID: String {
        return id.uuidString + "DESTINATION"
    }
}
var mockProfiles: [Profile]=[
    .init(name: "scenery", icon: "user"),
    .init(name: "person", icon: "user1"),
]
