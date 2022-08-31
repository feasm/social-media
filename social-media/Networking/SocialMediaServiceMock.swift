//
//  SocialMediaServiceMock.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Combine
import Foundation

final class SocialMediaServiceMock: SocialMediaService {
    
    private var users = [UserModel]()
    private var posts = [PostModel]()
    
    func getUser(id: Int?) -> UserModel? {
        return users.first(where: { $0.id == id })
    }
    
    func getUsers() -> AnyPublisher<[UserModel], NetworkError> {
        if users.isEmpty {
            return Utils.loadJsonFrom(type: [UserModel].self, file: "Users")
                        .handleEvents(receiveOutput: { users in
                            self.users = users
                        })
                        .mapError({ .mockError($0) })
                        .eraseToAnyPublisher()
        } else {
            return Just(users)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        }
    }
    
    func getPost(id: Int?) -> PostModel? {
        return posts.first(where: { $0.id == id })
    }
    
    func getPosts() -> AnyPublisher<[PostModel], NetworkError> {
        if posts.isEmpty {
            return Utils.loadJsonFrom(type: [PostModel].self, file: "Posts")
                        .handleEvents(receiveOutput: { posts in
                            self.posts = posts
                        })
                        .mapError({ .mockError($0) })
                        .eraseToAnyPublisher()
        } else {
            return Just(posts)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        }
    }
    
    func addPost(post: PostModel) -> AnyPublisher<PostModel, NetworkError> {
        if posts.filter({ $0.id == post.userInfo?.id && post.creationDate == $0.creationDate }).count < 5 {
            posts.insert(post, at: 0)
            return Just(post)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.maxPosts)
                    .eraseToAnyPublisher()
        }
    }
}
