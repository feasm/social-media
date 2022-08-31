//
//  PostModel.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Foundation

struct PostModel: Decodable {
    let id: Int?
    let type: PostType?
    let userInfo: UserModel?
    let repostInfo: PostInfoModel?
    let quoteInfo: PostInfoModel?
    let text: String?
    let creationDate: String?
    
    func toViewData() -> PostViewData? {
        guard let type = type else { return nil }
        
        switch type {
        case .post:
            return PostViewData(username: userInfo?.username ?? "",
                                text: text ?? "",
                                creationDate: self.creationDate ?? "")
        case .quote:
            let quoteViewData = PostViewData(username: quoteInfo?.username ?? "",
                                             text: quoteInfo?.text ?? "",
                                             creationDate: self.creationDate ?? "")
            return PostViewData(username: userInfo?.username ?? "",
                                text: text ?? "",
                                creationDate: self.creationDate ?? "",
                                quoteViewData: quoteViewData)
        case .repost:
            return PostViewData(username: repostInfo?.username ?? "",
                                text: repostInfo?.text ?? "",
                                repostUsername: userInfo?.username,
                                creationDate: self.creationDate ?? "")
        }
    }
    
    enum PostType: String, Decodable {
        case post = "post"
        case quote = "quote"
        case repost = "repost"
    }
}

struct PostInfoModel: Decodable {
    let userId: Int?
    let username: String?
    let text: String?
}
