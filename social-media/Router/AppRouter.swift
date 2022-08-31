//
//  AppRouter.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 30/08/22.
//

import SwiftUI

final class AppRouter {
    let service: SocialMediaService
    var currentUserId = 1
    
    init(service: SocialMediaService) {
        self.service = service
    }
    
    func start() -> some View {
        let viewModel = HomeViewModel(router: self,
                                      currentUserId: currentUserId,
                                      service: service)
        return HomeView(viewModel: viewModel)
    }
    
    func showUserScreen(userModel: UserModel) -> some View {
        let viewModel = UserViewModel(service: service, userModel: userModel)
        return UserView(viewModel: viewModel)
    }
}
