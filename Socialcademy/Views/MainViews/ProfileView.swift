//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/4/24.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ProfileImageView(url: viewModel.imageURL)
                    .frame(width: 200, height: 200)
                Spacer()
                Text(viewModel.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ImagePickerButton(imageURL: $viewModel.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .alert("Error", error: $viewModel.error)
            .disabled(viewModel.isWorking)
            .toolbar {
                Button("Sign Out", action: {
                    viewModel.signOut()
                })
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(user: User.testUser, authService: AuthService()))
    }
}
