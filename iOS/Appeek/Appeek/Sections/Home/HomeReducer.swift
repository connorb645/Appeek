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
    HomeStateCombined,
    HomeAction,
    HomeEnvironment
>

let homeReducer = Reducer<HomeStateCombined, HomeAction, HomeEnvironment>.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return .none
        case .goToSettingsTapped:
            state.viewState.route = .settings
            return .none
        case let .homeRouteChanged(route):
            state.viewState.route = route
            if route == nil {
                state.organisationTeamMembersStateCombined = nil
                state.settingsStateCombined = nil
            }
            return .none
        case .goToTeamMembersListTapped:
            state.viewState.route = .organisationMembersList
            return .none
        case .settingsAction(.loggedOut):
            state.viewState.route = nil
            return .task {
                await environment.delay(0.33)
                return .sheetDismissalDelayEnded(loggedOut: true)
            }
        case .settingsAction(.dismissScreenTapped),
             .organisationMembersAction(.dismissTapped):
            state.viewState.route = nil
            return .task {
                await environment.delay(0.33)
                return .sheetDismissalDelayEnded(loggedOut: false)
            }
        default:
            return .none
        }
    },
    settingsReducer.optional().pullback(
        state: \.settingsStateCombined,
        action: /HomeAction.settingsAction,
        environment: { SettingsEnvironment(logout: $0.logout,
                                           clearAuthSession: $0.clearAuthSession) }
    ),
    organisationMembersReducer.optional().pullback(
        state: \.organisationTeamMembersStateCombined,
        action: /HomeAction.organisationMembersAction,
        environment: {
            OrganisationMembersEnvironment(
                organisationTeamMembersClient: $0.organisationTeamMembersClient
            )
        }
    )
)
