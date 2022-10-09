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
            state = AppState.organisationsListState(.init())
            return .none
        case let .receivedAuthSession(.failure(error)):
            state = AppState.onboarding(.init())
            return .none
        case .onboardingAction(.signUpAction(.loggedIn)),
             .onboardingAction(.signUpAction(.loginAction(.loggedIn))):
            state = AppState.organisationsListState(.init())
            return .none
        case let .organisationsListAction(.homeAction(.sheetDismissalDelayEnded(loggedOut))):
            if loggedOut {
                state = AppState.onboarding(.init())
            }
            return .none
        default:
            return .none
        }
    },
    organisationsListReducer.pullback(
        state: /AppState.organisationsListState,
        action: /AppAction.organisationsListAction,
        environment: {
            OrganisationsListEnvironment(
                usersOrganisations: $0.usersOrganisations,
                logout: $0.logout,
                clearAuthSession: $0.clearAuthSession,
                delay: delay(for:),
                organisationTeamMembersClient: $0.organisationTeamMembersClient
            )
        }
    ),
    onboardingReducer.pullback(
        state: /AppState.onboarding,
        action: /AppAction.onboardingAction,
        environment: {
            OnboardingEnvironment(
                signUpClient: $0.signUpClient,
                loginClient: $0.loginClient,
                validationClient: $0.validationClient,
                resetPassword: $0.resetPassword
            )
        }
    )
).debug()

