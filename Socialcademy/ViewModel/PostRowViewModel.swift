//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/3/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject, StateManager {
    typealias Action = () async throws -> Void
    var canDeletePost: Bool { deleteAction != nil }
    @Published var post: Post
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
        post[keyPath: keyPath]
    }
    
    private let deleteAction: Action?
    private let favoriteAction: Action
    
    init(post: Post, deleteAction: Action?, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }

    
    func deletePost() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete post: no delete action provided")
        }
        withStateManagingTask(perform: deleteAction)
    }
    
    func favoritePost() {
        withStateManagingTask(perform: favoriteAction)
    }
    
}
