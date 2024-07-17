//
//  Posts.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import Foundation

struct Post: Identifiable,Equatable{
    var id = UUID()
    var title: String
    var content: String
    var author: User
    var timestamp: Date = Date()
    var isFavorite: Bool = false
    var imageURL: URL?

    
    func contains(_ string: String)-> Bool {
        let properties = [title, content, author.name].map { $0.lowercased()}
        let query = string.lowercased()
        let matches = properties.filter {$0.contains(query)}
        return !matches.isEmpty
    }
}
extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, timestamp, id, imageURL
    }
}


extension Post{
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        author: User.testUser
    )
}
