//
//  PostViewData.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Foundation

class PostViewData: Identifiable {
    let username: String
    let text: String
    var repostUsername: String?
    var creationDate: String
    var quoteViewData: PostViewData?
    
    var isRepost: Bool {
        return repostUsername != nil
    }
    
    init(username: String, text: String, repostUsername: String? = nil, creationDate: String, quoteViewData: PostViewData? = nil) {
        self.username = username
        self.text = text
        self.creationDate = creationDate
        
        if let repostUsername = repostUsername {
            self.repostUsername = "\(repostUsername) reposted"
        }
        
        self.quoteViewData = quoteViewData
    }
}
