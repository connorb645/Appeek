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
    HomeState,
    HomeAction,
    HomeEnvironment
>

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                await send(.usersOrganisationsReceived(TaskResult {
                    try await environment.usersOrganisations()
                }), animation: .default)
            }
        case .goToSettingsTapped:
            state.route = .settings
            return .none
        case let .usersOrganisationsReceived(.success(organisations)):
            state.selectedOrganisation = organisations.first
            state.usersOrganisations = organisations
            state.isLoading = false
            return .none
        case let .usersOrganisationsReceived(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.friendlyMessage
            return .none
        case let .selectedOrganisationUpdated(organisation):
            state.selectedOrganisation = organisation
            return .none
        case let .homeRouteChanged(route):
            state.route = route
            if route == nil {
                state.organisationTeamMembersStateCombined = nil
                state.settingsStateCombined = nil
            }
            return .none
        case .goToTeamMembersListTapped:
            state.route = .organisationMembersList
            return .none
        case .settingsAction(.loggedOut):
            state.route = nil
            return .task {
                await environment.delay(0.33)
                return .sheetDismissalDelayEnded(loggedOut: true)
            }
        case .settingsAction(.dismissScreenTapped):
            state.route = nil
            return .task {
                await environment.delay(0.33)
                return .sheetDismissalDelayEnded(loggedOut: false)
            }
        default:
            return .none
        }
    },
    settingsReducer.optional().pullback(
        state: \HomeState.settingsStateCombined,
        action: /HomeAction.settingsAction,
        environment: { SettingsEnvironment(logout: $0.logout,
                                           clearAuthSession: $0.clearAuthSession) }
    ),
    organisationMembersReducer.optional().pullback(
        state: \.organisationTeamMembersStateCombined,
        action: /HomeAction.organisationMembersAction,
        environment: {
            OrganisationMembersEnvironment(
                fetchTeamMembersForOrganisation: $0.fetchTeamMembersForOrganisation
            )
        }
    )
)
