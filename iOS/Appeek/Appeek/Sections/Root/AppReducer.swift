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
        case let .receivedAuthSession(.success(authSession)):
            state = AppState.home(.init())
            return .none
        case let .receivedAuthSession(.failure(error)):
            state = AppState.onboarding(.init())
            return .none
        case .onboardingAction(.signUpAction(.loggedIn)),
             .onboardingAction(.signUpAction(.loginAction(.loggedIn))):
            state = AppState.home(.init())
            return .none
        case let .homeAction(.sheetDismissalDelayEnded(loggedOut)):
            if loggedOut {
                state = AppState.onboarding(.init())
            }
            return .none
        default:
            return .none
        }
    },
    homeReducer.pullback(
        state: /AppState.home,
        action: /AppAction.homeAction,
        environment: {
            HomeEnvironment(logout: $0.logout,
                            clearAuthSession: $0.clearAuthSession,
                            usersOrganisations: $0.usersOrganisations,
                            delay: { _ in }
            )
        }
    ),
    onboardingReducer.pullback(
        state: /AppState.onboarding,
        action: /AppAction.onboardingAction,
        environment: {
            OnboardingEnvironment(signUpClient: $0.signUpClient,
                                  loginClient: $0.loginClient,
                                  validationClient: $0.validationClient,
                                  resetPassword: $0.resetPassword)
        }
    )
).debug()

