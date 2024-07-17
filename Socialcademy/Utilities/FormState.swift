//
//  FormState.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import Foundation


enum FormState {
    case idle, working, error
    
    var isError: Bool {
        get {
            self == .error
        }
        set {
            guard !newValue else { return }
            self = .idle
        }
    }
}
