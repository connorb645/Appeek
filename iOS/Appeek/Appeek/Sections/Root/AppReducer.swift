//
//  AppReducer.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture
import CasePaths

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    .init { state, action, environment in
        switch action {
        case .onAppear:
            return .none
        case .onboardingNavigationPathChanged(let navigationPath):
            var currentRoute = (/AppRoute.onboarding).extract(from: state.route) ?? .init()
            currentRoute.navigationPath = navigationPath
            state.route = (/AppRoute.onboarding).embed(currentRoute)
            return .none
        case .homeNavigationPathChanged(let navigationPath):
            var currentRoute = (/AppRoute.home).extract(from: state.route) ?? .init()
            currentRoute.navigationPath = navigationPath
            state.route = (/AppRoute.home).embed(currentRoute)
            return .none
        default:
            return .none
        }
    },
    onboardingReducer.pullback(
        state: \.onboarding,
        action: /AppAction.onboarding,
        environment: { _ in .init() }
    ),
    signUpReducer.pullback(
        state: \.signUpStateWithRoute,
        action: /AppAction.signUp,
        environment: { SignUpEnvironment(createAccount: $0.authenticateClient.createAccount(email:password:),
                                         persistAuthenticationState: $0.authenticateClient.persistAuthenticationState(_:),
                                         validationClient: $0.validationClient,
                                         mainQueue: $0.mainQueue) }
    ),
    loginReducer.pullback(
        state: \.loginStateWithRoute,
        action: /AppAction.login,
        environment: { LoginEnvironment(login: $0.authenticateClient.login(email:password:),
                                        persistAuthenticationState: $0.authenticateClient.persistAuthenticationState(_:),
                                        validate: $0.validationClient.validate(_:),
                                        mainQueue: $0.mainQueue) }
    ),
    forgotPasswordReducer.pullback(
        state: \.forgotPasswordStateWithRoute,
        action: /AppAction.forgotPassword,
        environment: { ForgotPasswordEnvironment(resetPassword: $0.authenticateClient.resetPassword(email:),
                                                 validate: $0.validationClient.validate(_:),
                                                 mainQueue: $0.mainQueue) }
    )
)
