//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/5/24.
//

import Foundation


@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager  {
    @Published var comment: Comment
    @Published var error: Error?
    typealias Action = () async throws -> Void
    private let deleteAction: Action?
    var canDeleteComment: Bool { deleteAction != nil }
    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }
    
    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }
    
    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    }
    
    private func withErrorHandlingTask(perform action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                print("[PostRowViewModel] Error: \(error)")
                self.error = error
            }
        }
    }
}
