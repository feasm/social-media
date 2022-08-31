//
//  ContentView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 04/08/22.
//

import SwiftUI
import Combine

struct UserView: View {
    let imageSize: CGFloat = 80
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            userInfo
            
            HomeView(viewModel: viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var userInfo: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            HStack {
                Spacer()
                
                Image(systemName: "person.circle")
                    .frame(width: imageSize, height: imageSize)
                    .font(.system(size: imageSize))
                
                Spacer()
            }
            
            headerLineView(title: "Username:", value: viewModel.currentUser.username)
            
            headerLineView(title: "Date joined:", value: viewModel.currentUser.creationDate)
            
            headerLineView(title: "Number of posts:", value: viewModel.currentUser.numberOfPosts)
            
            headerLineView(title: "Number of reposts:", value: viewModel.currentUser.numberOfReposts)
            
            headerLineView(title: "Number of quotes:", value: viewModel.currentUser.numberOfQuotes)
        }
        .padding([.leading, .trailing], DesignSystem.Margin.big)
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
        AppRouter(service: SocialMediaServiceMock()).showUserScreen(currentUserId: 1)
    }
}
