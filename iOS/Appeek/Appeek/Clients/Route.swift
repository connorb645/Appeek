//
//  Route.swift
//  Appeek
//
//  Created by Connor Black on 30/07/2022.
//

import SwiftUI

struct OnboardingRouteStack {
    var navigationPath: NavigationPath = .init()
    
    init(_ navigationPath: State...) {
        navigationPath.forEach { state in
            self.navigationPath.append(state)
        }
    }

    enum State {
        case signUp
        case login
        case forgotPassword
    }
    
    static let SignUpState = Self(.signUp)
    static let LoginState = Self(.signUp, .login)
    static let ForgotPasswordState = Self(.signUp, .login, .forgotPassword)
}

extension OnboardingRouteStack: Equatable {}

struct HomeRouteStack {
    var navigationPath: NavigationPath = .init()

    enum State {
        
    }
}

extension HomeRouteStack: Equatable {}
