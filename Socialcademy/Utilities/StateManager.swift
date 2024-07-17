//
//  ErrorHandler.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/5/24.
//

import Foundation


@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
}


extension StateManager {
    typealias Action = () async throws -> Void
    nonisolated func withStateManagingTask(perform action: @escaping Action) {
        Task {
            await withStateManagement(perform: action)
        }
    }

    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        isWorking = false
    }
}


extension StateManager {
    var isWorking: Bool {
        get { false }
        set {}
    }
}
