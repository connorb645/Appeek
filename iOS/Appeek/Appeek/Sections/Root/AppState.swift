//
//  AppState.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture

enum AppState: Equatable {
    
//    enum Route: Equatable {
        case home(HomeState)
        case onboarding(OnboardingState)
//    }
    
//    var onboarding: OnboardingState
//    private var signUp: SignUpState
//    private var login: LoginState
//    private var forgotPassword: ForgotPasswordState
//    private var home: HomeState
    
//    var route: AppRoute
//    var _route: Route?
    
//    var homeState: HomeState? {
//        set {
//            _route = newValue.map(Route.home)
//        }
//        get {
//            guard case .home(let homeState) = _route else {
//                return nil
//            }
//            return homeState
//        }
//    }
    
//    var signUpStateWithRoute: SignUpStateWithRoute {
//        get {
//            .init(signUpState: self.signUp, route: self.route)
//        }
//        set {
//            self.signUp = newValue.signUpState
//            self.route = newValue.route
//        }
//    }
//
//    var loginStateWithRoute: LoginStateWithRoute {
//        get {
//            .init(loginState: self.login,
//                  route: self.route)
//        }
//        set {
//            self.login = newValue.loginState
//            self.route = newValue.route
//        }
//    }
//
//    var forgotPasswordStateWithRoute: ForgotPasswordStateWithRoute {
//         get {
//             .init(forgotPasswordState: self.forgotPassword,
//                   route: self.route)
//         }
//         set {
//             self.forgotPassword = newValue.forgotPasswordState
//             self.route = newValue.route
//         }
//     }
    
//    var homeStateWithRoute: HomeStateWithRoute {
//        get {
//            .init(state: self.home,
//                  route: self.route)
//        }
//        set {
//            self.home = newValue.state
//            self.route = newValue.route
//        }
//    }
    
    static let live = AppState.onboarding(.init())
    

}
