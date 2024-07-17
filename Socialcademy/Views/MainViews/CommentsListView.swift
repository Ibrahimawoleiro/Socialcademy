//
//  CommentsListView.swift
//  Socialcademy
//
//  Created by Ibrahim Awoleiro on 3/5/24.
//

import SwiftUI

struct CommentsListView: View {
    @StateObject var viewModel: CommentsViewModel
    
    var body: some View {
        Group {
            switch viewModel.comments {
                case .loading:
                    ProgressView()
                        .onAppear {
                            viewModel.fetchComments()
                        }
                case let .error(error):
                    EmptyListView(
                        title: "Cannot Load Comments",
                        message: error.localizedDescription,
                        retryAction: {
                            viewModel.fetchComments()
                        }
                    )
                case .empty:
                    EmptyListView(
                        title: "No Comments",
                        message: "Be the first to leave a comment."
                    )
                case let .loaded(comments):
                    List(comments) { comment in
                        CommentRowView(viewModel: viewModel.makeCommentRowViewModel(for: comment))
                    }
                    .animation(.default, value: comments)
            }
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                NewCommentForm(viewModel: viewModel.makeNewCommentViewModel())
            }
            
        }
        
    }
}

private extension CommentsListView{
    struct NewCommentForm: View {
        @StateObject var viewModel: FormViewModel<Comment>
        
        var body: some View {
            HStack {
                TextField("Comment", text: $viewModel.content)
                Spacer()
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Label("Post", systemImage: "paperplane")
                    }
                }
            }
            .alert("Cannot Post Comment", error: $viewModel.error)
            .animation(.default, value: viewModel.isWorking)
            .disabled(viewModel.isWorking)
            .onSubmit(viewModel.submit)
        }
    }
}


#if DEBUG
struct CommentsList_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview(state: .loaded([Comment.testComment]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    private struct ListPreview: View {
        let state: Loadable<[Comment]>
        
        var body: some View {
            NavigationView {
                CommentsListView(viewModel: CommentsViewModel(commentsRepository: CommentsRepositoryStub(state: state)))
            }
        }
    }
}
#endif
