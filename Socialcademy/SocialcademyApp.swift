//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    
    init(){
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
