//
//  HomeReducer.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias HomeReducer = Reducer<
    HomeStateWithRoute,
    HomeAction,
    HomeEnvironment
>

let homeReducer = Reducer<HomeStateWithRoute, HomeAction, HomeEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return .run { send in
                await send(.usersOrganisationsReceived(TaskResult {
                    try await environment.usersOrganisations()
                }), animation: .default)
            }
        case .goToSettingsTapped:
            state.state.homeRoute = .settings
            return .none
        case let .usersOrganisationsReceived(.success(organisations)):
            state.state.selectedOrganisation = organisations.first
            state.state.usersOrganisations = organisations
            return .none
        case let .usersOrganisationsReceived(.failure(error)):
            state.state.errorMessage = error.friendlyMessage
            return .none
        case let .selectedOrganisationUpdated(organisation):
            state.state.selectedOrganisation = organisation
            return .none
        case let .homeRouteChanged(route):
            state.state.homeRoute = route
            return .none
        case .goToTeamMembersListTapped:
            state.state.homeRoute = .organisationMembersList
            return .none
        default:
            return .none
        }
    },
    settingsReducer.pullback(
        state: \HomeStateWithRoute.settingsState,
        action: /HomeAction.settingsAction,
        environment: { SettingsEnvironment(logout: $0.logout,
                                           clearAuthSession: $0.clearAuthSession,
                                           delay: delay(for:)) }
    )
)
