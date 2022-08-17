//
//  AppState.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture

struct AppState: Equatable {
    var onboarding: OnboardingState
    private var signUp: SignUpState
    private var login: LoginState
    private var forgotPassword: ForgotPasswordState
    private var home: HomeState
    
    var route: AppRoute
    
    var signUpStateWithRoute: SignUpStateWithRoute {
        get {
            .init(signUpState: self.signUp, route: self.route)
        }
        set {
            self.signUp = newValue.signUpState
            self.route = newValue.route
        }
    }
    
    var loginStateWithRoute: LoginStateWithRoute {
        get {
            .init(loginState: self.login,
                  route: self.route)
        }
        set {
            self.login = newValue.loginState
            self.route = newValue.route
        }
    }
                          
    var forgotPasswordStateWithRoute: ForgotPasswordStateWithRoute {
         get {
             .init(forgotPasswordState: self.forgotPassword,
                   route: self.route)
         }
         set {
             self.forgotPassword = newValue.forgotPasswordState
             self.route = newValue.route
         }
     }
    
    var homeStateWithRoute: HomeStateWithRoute {
        get {
            .init(state: self.home,
                  route: self.route)
        }
        set {
            self.home = newValue.state
            self.route = newValue.route
        }
    }
    
    static let live = Self(onboarding: OnboardingState(),
                           signUp: SignUpState(),
                           login: LoginState(),
                           forgotPassword: ForgotPasswordState(),
                           home: HomeState(),
                           route: .onboarding(.init()))

}
