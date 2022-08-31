//
//  ContentView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 04/08/22.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: headerView) {
                    ForEach(viewModel.posts.indices, id: \.self) { index in
                        NavigationLink(destination: viewModel.showUserScreen(index: index)) {
                            PostView(viewData: viewModel.posts[index],
                                     onShareEvent: { viewModel.repostContent(index: index) },
                                     onQuoteEvent: { viewModel.quoteContent(index: index) })
                        }
                    }
                }
            }
            .buttonStyle(.borderless)
            .listStyle(.plain)
            .onAppear {
                viewModel.getPosts()
            }
            .navigationTitle("Home")
            .alert(viewModel.errorMessage, isPresented: $viewModel.isShowingAlert) {
                Button("Ok", role: .cancel) {
                    viewModel.clearStates()
                }
            }
        }
    }
    
    var headerView: some View {
        NewTweetView(newPost: $viewModel.newPost,
                     numberOfLettersLeft: $viewModel.numberOfLettersLeft,
                     quotePost: $viewModel.quotePost,
                     isFocused: $viewModel.isFocused,
                     username: viewModel.currentUser?.username ?? "",
                     onTweetButtonPressed: { viewModel.postNewContent() })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppRouter(service: SocialMediaServiceMock()).start()
    }
}
