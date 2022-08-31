//
//  HomeViewModel.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    private let router: AppRouter
    let currentUserId: Int
    let service: SocialMediaService
    
    @Published var newPost: String = "" {
        didSet {
            numberOfLettersLeft = "\(HomeViewModel.maxNumberOfLetters - newPost.count) characters left"
        }
    }
    @Published var numberOfLettersLeft: String = "\(maxNumberOfLetters) characters left"
    @Published var posts = [PostViewData]()
    @Published var quotePost: PostViewData?
    @Published var isShowingAlert = false {
        didSet {
            if !isShowingAlert {
                errorMessage = ""
            }
        }
    }
    @Published var isFocused = false
    
    var currentUserModel: UserModel?
    var currentUser: UserViewData {
        return .init(username: currentUserModel?.username ?? "",
                     creationDate: currentUserModel?.creationDate ?? "",
                     numberOfPosts: "\(postModels.filter({ $0.type == .post }).count)",
                     numberOfReposts: "\(postModels.filter({ $0.type == .repost }).count)",
                     numberOfQuotes: "\(postModels.filter({ $0.type == .quote }).count)")
    }
    
    var errorMessage: String = ""
    
    static let maxNumberOfLetters: Int = 777
    var cancellables = [AnyCancellable]()
    var postModels = [PostModel]()
    
    private var userModels = [UserModel]()
    private var quotePostModel: PostModel? {
        didSet {
            quotePost = PostViewData(username: quotePostModel?.userInfo?.username ?? "",
                                     text: quotePostModel?.text ?? "",
                                     repostUsername: nil,
                                     creationDate: quotePostModel?.creationDate ?? "",
                                     quoteViewData: nil)
        }
    }
    
    init(router: AppRouter, currentUserId: Int, service: SocialMediaService = SocialMediaServiceMock()) {
        self.router = router
        self.currentUserId = currentUserId
        self.service = service
    }
    
    func getPosts() {
        clearStates()
        
        Publishers.Zip(
            service.getUsers(),
            service.getPosts()
        ).sink(
            receiveCompletion: { print($0) },
            receiveValue: { [weak self] (userModels, postModels) in
                guard let self = self else { return }
                
                self.currentUserModel = userModels.first(where: { $0.id == self.currentUserId })
                self.userModels = userModels
                self.postModels = self.filterPostModels(postModels)
                
                self.posts = self.postModels.compactMap({ $0.toViewData() })
            }
        ).store(in: &cancellables)
    }
    
    func addPost(_ postModel: PostModel) {
        service
            .addPost(post: postModel)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.description
                    self?.isShowingAlert = true
                case .finished:
                    return
                }
            } receiveValue: { _ in
                self.getPosts()
            }
            .store(in: &cancellables)
    }
    
    func repostContent(index: Int) {
        let post = postModels[index]

        let postInfoModel = post.repostInfo ?? PostInfoModel(userId: post.userInfo?.id,
                                                             username: post.userInfo?.username,
                                                             text: post.text)
        
        let newPostModel = PostModel(id: self.currentUserId,
                                     type: .repost,
                                     userInfo: self.currentUserModel,
                                     repostInfo: postInfoModel,
                                     quoteInfo: nil,
                                     text: nil,
                                     creationDate: Date().formatDate())
        
        self.addPost(newPostModel)
    }
    
    func quoteContent(index: Int) {
        let post = postModels[index]
        quotePostModel = post
        isFocused = true
    }
    
    func postNewContent() {
        if newPost != "" {
            let quoteInfo = self.quotePostModel.map { postModel in
                PostInfoModel(userId: postModel.userInfo?.id,
                              username: postModel.userInfo?.username,
                              text: postModel.text)
            }
            
            let newPostModel = PostModel(id: currentUserId,
                                         type: quoteInfo == nil ? .post : .quote,
                                         userInfo: self.currentUserModel,
                                         repostInfo: nil,
                                         quoteInfo: quoteInfo,
                                         text: newPost,
                                         creationDate: Date().formatDate())
            
            addPost(newPostModel)
            clearStates()
        } else {
            errorMessage = "Post message can't be blank"
            isShowingAlert = true
        }
    }
    
    func clearStates() {
        newPost = ""
        isFocused = false
        quotePost = nil
    }
    
    func filterPostModels(_ postModels: [PostModel]) -> [PostModel] {
        return postModels
    }
    
    func showUserScreen(index: Int) -> some View {
        let postModel = postModels[index]
        let selectedUserId = postModel.userInfo?.id ?? 0
        return router.showUserScreen(currentUserId: selectedUserId)
    }
}

class UserViewModel: HomeViewModel {
    override func filterPostModels(_ postModels: [PostModel]) -> [PostModel] {
        return postModels.filter({ $0.userInfo?.id == self.currentUserModel?.id })
    }
}
