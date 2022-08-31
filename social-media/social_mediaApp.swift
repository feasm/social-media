//
//  social_mediaApp.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 04/08/22.
//

import SwiftUI

@main
struct social_mediaApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter(service: SocialMediaServiceMock()).start()
        }
    }
}
