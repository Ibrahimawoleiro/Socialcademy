//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/4/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject , StateManager {
    typealias Action = (Value) async throws -> Void
    @Published var isWorking = false
    @Published var value: Value
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
    
    private let action: Action
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    
    nonisolated func submit() {
        withStateManagingTask { [self] in
            try await action(value)
        }
    }
}
