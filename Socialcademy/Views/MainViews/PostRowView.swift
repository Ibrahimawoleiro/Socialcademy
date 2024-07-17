//
//  PostRow.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import SwiftUI

struct PostRowView: View {
    @ObservedObject var viewModel: PostRowViewModel
    @State private var showConfirmationDialog = false
    @EnvironmentObject private var factory: ViewModelFactory
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            HStack{
                AuthorView(author: viewModel.author)
                Spacer()
                Text(viewModel.timestamp.formatted(date:.abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            if let imageURL = viewModel.imageURL {
                PostImage(url: imageURL)
            }
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            HStack{
                FavoriteButtonView(isFavorite: viewModel.isFavorite, action: {viewModel.favoritePost()})
                NavigationLink {
                    CommentsListView(viewModel: factory.makeCommentsViewModel(for: viewModel.post))
                } label: {
                    Label("Comments", systemImage: "text.bubble")
                        .foregroundColor(.secondary)
                }
                Spacer()
                if viewModel.canDeletePost {
                    Button(role: .destructive, action: {
                        showConfirmationDialog = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    
                }
                
            }
            .labelStyle(.iconOnly)
        }
        .padding()
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {viewModel.deletePost()})
        }
        .alert("Cannot Delete Post", error: $viewModel.error)
    }
}



extension PostRowView{
    struct AuthorView: View {
        let author: User
        
        @EnvironmentObject private var factory: ViewModelFactory
        
        var body: some View {
            NavigationLink {
                ProfileImageView(url: author.imageURL)
                    .frame(width: 40, height: 40)
                PostsListView(viewModel: factory.makePostsViewModel(filter: .author(author)))
            } label: {
                Text(author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }

}

private extension PostRowView{
    struct PostImage: View {
        let url: URL
        
        var body: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Color.clear
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
            .previewLayout(.sizeThatFits)
            .environmentObject(ViewModelFactory.preview)
    }
}
