//
//  HomeViewModel.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/2/19.
//

import SwiftUI

struct User: Identifiable {
    var id = UUID().uuidString
    var name: String
    var place: String
    var profilePic: String
}

class HomeViewModel: ObservableObject {
    @Published var fatched_users: [User] = []
    @Published var displaying_users: [User]?
    
    init() {
        fatched_users = [
            User(name: "name1", place: "10", profilePic: "user1"),
            User(name: "name2", place: "20", profilePic: "user2"),
            User(name: "name3", place: "30", profilePic: "user3"),
            User(name: "name4", place: "40", profilePic: "user4"),
            User(name: "name5", place: "50", profilePic: "user5"),
            User(name: "name6", place: "60", profilePic: "user6"),
        ]
        
        displaying_users = fatched_users
    }
    
    func getIndex(user: User) -> Int {
        return displaying_users?.firstIndex(where: { contentUser in
            return contentUser.id == user.id
        }) ?? 0
    }
    
    func reloadData() {
        displaying_users = fatched_users
    }
}
