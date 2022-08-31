//
//  UserModel.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 29/08/22.
//

import Foundation

struct UserModel: Decodable {
    let id: Int?
    let username: String?
    let creationDate: String?
}
