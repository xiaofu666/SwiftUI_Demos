//
//  NoteModel.swift
//  NotesApp
//
//  Created by Xiaofu666 on 2024/9/23.
//

import SwiftUI
import SwiftData

@Model
class NoteModel {
    init(colorString: String, title: String, content: String, allowsHitTesting: Bool = false) {
        self.colorString = colorString
        self.title = title
        self.content = content
        self.allowsHitTesting = allowsHitTesting
    }
    
    var id: String = UUID().uuidString
    var dateCreated: Date = Date()
    var colorString: String
    var title: String
    var content: String
    var allowsHitTesting: Bool = false
    
    var color: Color {
        Color(colorString)
    }
}
