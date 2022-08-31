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
        return AppView(viewModel: viewModel)
    }
    
    func showUserScreen(currentUserId: Int) -> some View {
        let viewModel = UserViewModel(router: self, currentUserId: currentUserId, service: service)
        return UserView(viewModel: viewModel)
    }
}
