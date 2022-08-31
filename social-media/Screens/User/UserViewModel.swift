//
//  UserViewModel.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 30/08/22.
//

import SwiftUI
import Combine

final class UserViewModel1: ObservableObject {
    private let service: SocialMediaService
    private let userModel: UserModel
    let homeViewModel: HomeViewModel
    
    @Published var newPost: String = "" {
        didSet {
            numberOfLettersLeft = "\(HomeViewModel.maxNumberOfLetters - newPost.count) characters left"
        }
    }
    @Published var quotePost: PostViewData?
    @Published var posts = [PostViewData]()
    @Published var numberOfLettersLeft: String = "\(maxNumberOfLetters) characters left"
    @Published var isFocused = false
    
    var user: UserViewData {
        return .init(username: userModel.username ?? "",
                     creationDate: userModel.creationDate ?? "",
                     numberOfPosts: "\(postModels.filter({ $0.type == .post }).count)",
                     numberOfReposts: "\(postModels.filter({ $0.type == .repost }).count)",
                     numberOfQuotes: "\(postModels.filter({ $0.type == .quote }).count)")
    }
    
    static let maxNumberOfLetters: Int = 777
    private var postModels = [PostModel]()
    private var cancellables = [AnyCancellable]()
    
    init(service: SocialMediaService = SocialMediaServiceMock(), userModel: UserModel, homeViewModel: HomeViewModel) {
        self.service = service
        self.userModel = userModel
        self.homeViewModel = homeViewModel
    }
    
    func getPosts() {
        service
            .getPosts()
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { [weak self] postModels in
                guard let self = self else { return }
                
                self.postModels = postModels.filter({ $0.userInfo?.id == self.userModel.id })
                self.posts = self.postModels.compactMap({ $0.toViewData() })
            })
            .store(in: &cancellables)
    }
}
