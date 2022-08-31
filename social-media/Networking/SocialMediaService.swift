//
//  SocialMediaService.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Foundation
import Combine

enum NetworkError: Error {
    case mockError(MockError)
    case maxPosts
    
    var description: String {
        switch self {
        case .mockError(let error):
            return error.description
        case .maxPosts:
            return "Can't add more than 5 posts per day"
        }
    }
}

protocol SocialMediaService {
    func getUser(id: Int?) -> UserModel?
    func getUsers() -> AnyPublisher<[UserModel], NetworkError>
    
    func getPost(id: Int?) -> PostModel?
    func getPosts() -> AnyPublisher<[PostModel], NetworkError>
    
    func addPost(post: PostModel) -> AnyPublisher<PostModel, NetworkError>
}
