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
//            return .fireAndForget {
//                environment.clearAuthSession()
//            }
        case .onboardingNavigationPathChanged(let navigationPath):
//            var currentRoute = (/AppRoute.onboarding).extract(from: state.route) ?? .init()
//            currentRoute.navigationPath = navigationPath
//            state.route = (/AppRoute.onboarding).embed(currentRoute)
            return .none
        case .homeNavigationPathChanged(let navigationPath):
//            var currentRoute = (/AppRoute.home).extract(from: state.route) ?? .init()
//            currentRoute.navigationPath = navigationPath
//            state.route = (/AppRoute.home).embed(currentRoute)
            return .none
        case let .receivedAuthSession(.success(authSession)):
            state = AppState.home(.init())
            return .none
        case let .receivedAuthSession(.failure(error)):
            state = AppState.onboarding(.init())
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
                            usersOrganisations: $0.usersOrganisations
            )
        }
    ),
    onboardingReducer.pullback(
        state: /AppState.onboarding,
        action: /AppAction.onboardingAction,
        environment: {
            OnboardingEnvironment(signUpClient: $0.signUpClient,
                                  validationClient: $0.validationClient)
        }
    )
).debug()

