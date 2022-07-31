//
//  Route.swift
//  Appeek
//
//  Created by Connor Black on 30/07/2022.
//

import SwiftUI

struct OnboardingRouteStack {
    var navigationPath: NavigationPath
    
    init(_ navigationPath: State...) {
        self.navigationPath = .init()
        navigationPath.forEach { state in
            self.navigationPath.append(state)
        }
    }

    enum State {
        case signUp
    }
    
    static let SignUpState = Self(.signUp)
}

extension OnboardingRouteStack: Equatable {}

struct HomeRouteStack {
    var navigationPath: NavigationPath = .init()

    enum State {
        
    }
}

extension HomeRouteStack: Equatable {}
