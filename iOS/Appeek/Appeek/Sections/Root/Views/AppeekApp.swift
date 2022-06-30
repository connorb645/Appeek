//
//  AppeekApp.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import SwiftUI

@main
struct AppeekApp: App {
    @StateObject var navigation = AppNavigation()
    @StateObject var authentication = Authentication()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let currentSession = authentication.currentSession {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(navigation)
            .environmentObject(authentication)
        }
    }
}
