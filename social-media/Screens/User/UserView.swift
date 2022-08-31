//
//  ContentView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 04/08/22.
//

import SwiftUI
import Combine

struct UserView: View {
    let imageSize: CGFloat = 120
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            List {
                userInfo
                
                Section(header: listHeader) {
                    NewTweetView(newPost: $viewModel.newPost,
                                 numberOfLettersLeft: $viewModel.numberOfLettersLeft,
                                 quotePost: $viewModel.quotePost,
                                 isFocused: $viewModel.isFocused,
                                 username: viewModel.user.username,
                                 onTweetButtonPressed: {  })
                    
                    ForEach(viewModel.posts) { postViewData in
                        PostView(viewData: postViewData)
                    }
                }
            }
            .listStyle(.plain)
            .onAppear {
                viewModel.getPosts()
            }
        }
    }
    
    var userInfo: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Spacer()
                
                Image(systemName: "person.circle")
                    .frame(width: imageSize, height: imageSize)
                    .font(.system(size: 80))
                
                Spacer()
            }
            
            headerLineView(title: "Username:", value: viewModel.user.username)
            
            headerLineView(title: "Date joined:", value: viewModel.user.creationDate)
            
            headerLineView(title: "Number of posts:", value: viewModel.user.numberOfPosts)
            
            headerLineView(title: "Number of reposts:", value: viewModel.user.numberOfReposts)
            
            headerLineView(title: "Number of quotes:", value: viewModel.user.numberOfQuotes)
        }
        .padding(DesignSystem.Margin.big)
    }
    
    var listHeader: some View {
        Text("Posts")
            .bold()
            .font(.title)
    }
    
    func headerLineView(title: String, value: String) -> some View {
        return HStack {
            Text(title)
                .font(.headline)
            
            Text(value)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel:
                    UserViewModel(userModel:
                                    UserModel(id: 1,
                                              username: "johnz",
                                              creationDate: "March 25, 2020")))
    }
}
