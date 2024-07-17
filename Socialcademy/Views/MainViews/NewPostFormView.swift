//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import SwiftUI

struct NewPostFormView: View {
    @StateObject var viewModel: FormViewModel<Post>
    
    @Environment(\.dismiss) private var dismiss
    

    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Title", text: $viewModel.title)
                }
                ImageSection(imageURL: $viewModel.imageURL)
                Section("Content"){
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }

                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .navigationTitle("New Post")
            .onSubmit(viewModel.submit)
        }
        .disabled(viewModel.isWorking)
        .alert("Cannot Create Post", error: $viewModel.error)
        .onChange(of: viewModel.isWorking) { isWorking in
            guard !isWorking, viewModel.error == nil else { return }
            dismiss()
        }
    }
    
}
private extension NewPostFormView{
    struct ImageSection: View {
        @Binding var imageURL: URL?
        
        var body: some View {
            Section("Image") {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    EmptyView()
                }
                ImagePickerButton(imageURL: $imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
            }
        }
    }

}



struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
        NewPostFormView(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in }))
    }
}
