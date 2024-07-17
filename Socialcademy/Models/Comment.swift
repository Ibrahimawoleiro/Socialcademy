//
//  File.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/5/24.
//

import Foundation


struct Comment: Identifiable, Equatable, Codable {
    var content: String
    var author: User
    var timestamp = Date()
    var id = UUID()
}

extension Comment {
    static let testComment = Comment(content: "Lorem ipsum dolor set amet.", author: User.testUser)
}
