//
//  AppReducer.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import ComposableArchitecture
import CasePaths
import Combine

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return .task {
                await .receivedAuthSession(TaskResult {
                    try environment.retrieveAuthSession()
                })
            }
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
        case let .receivedAuthSession(.success(authSession)):
            state.route = AppRoute.home(.init())
            return .none
        case let .receivedAuthSession(.failure(error)):
            state.route = AppRoute.onboarding(.init())
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
        environment: { SignUpEnvironment(
            signUpClient: $0.signUpClient,
            validationClient: $0.validationClient) }
    ),
    loginReducer.pullback(
        state: \.loginStateWithRoute,
        action: /AppAction.login,
        environment: { LoginEnvironment(loginClient: $0.loginClient,
                                        validate: $0.validationClient.validate(_:)) }
    ),
    forgotPasswordReducer.pullback(
        state: \.forgotPasswordStateWithRoute,
        action: /AppAction.forgotPassword,
        environment: { ForgotPasswordEnvironment(resetPassword: $0.resetPassword,
                                                 validate: $0.validationClient.validate(_:)) }
    ),
    homeReducer.pullback(state: \AppState.homeStateWithRoute,
                         action: /AppAction.homeAction,
                         environment: { HomeEnvironment(logout: $0.logout,
                                                        clearAuthSession: $0.clearAuthSession,
                                                        usersOrganisations: $0.usersOrganisations) }
    )
).debug()
