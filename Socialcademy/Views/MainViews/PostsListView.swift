//
//  PostsListView.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 2/23/24.
//

import SwiftUI

struct PostsListView: View {
    @StateObject var viewModel :PostsViewModel
    @State private var showNewPostForm = false
    @State var searchText = ""
    var body: some View {

            Group {
                switch viewModel.posts {
                    case .loading:
                        ProgressView()
                    case let .error(error):
                        EmptyListView(
                            title: "Cannot Load Posts",
                            message: error.localizedDescription,
                            retryAction: {
                                viewModel.fetchPosts()
                            }
                        )
                    case .empty:
                        EmptyListView(
                            title: "No Posts",
                            message: "There aren’t any posts yet."
                        )
                    case let .loaded(posts):
                        ScrollView {
                            ForEach(posts) { post in
                                if searchText.isEmpty || post.contains(searchText) {
                                    PostRowView(viewModel: viewModel.makePostRowViewModel(for: post))
                                }
                            }
                            .searchable(text: $searchText)
                            .animation(.default, value: posts)
                        }
                }
            }
            .navigationTitle(viewModel.title)
            .onAppear{
                viewModel.fetchPosts()
            }
            .toolbar {
                Button {
                    showNewPostForm = true
                } label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
            .sheet(isPresented: $showNewPostForm) {
                NewPostFormView(viewModel: viewModel.makeNewPostViewModel())
            }

        
    }
        
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        
        var body: some View {
            let postsRepository = PostsRepositoryStub(state: state)
            let viewModel = PostsViewModel(postsRepository: postsRepository)
            NavigationView {
                PostsListView(viewModel: viewModel)
            }
        }
    }
}
#endif
