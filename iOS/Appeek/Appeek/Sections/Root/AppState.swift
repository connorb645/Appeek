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
    
    var route: AppRoute
    var isLoggedIn: Bool

//    private var _onboardingRouteStack: OnboardingRouteStack? {
//        get {
//            (/AppRoute.onboarding).extract(from: self.route)
//        }
//        set {
//            guard let newValue = newValue else { return }
//            self.route = (/AppRoute.onboarding).embed(newValue)
//        }
//    }
    
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
    
    static let live = Self(onboarding: OnboardingState(),
                           signUp: SignUpState(),
                           login: LoginState(),
                           forgotPassword: ForgotPasswordState(),
                           route: .onboarding(.init()),
                           isLoggedIn: false)

}
