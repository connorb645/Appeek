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
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(navigation)
        }
    }
}
