//
//  OrganisationsListReducer.swift
//  Appeek
//
//  Created by Connor Black on 02/10/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias OrganisationsListReducer = Reducer<
    OrganisationsListState,
    OrganisationsListAction,
    OrganisationsListEnvironment
>

let organisationsListReducer = OrganisationsListReducer.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                await send(.usersOrganisationsReceived(TaskResult {
                    try await environment.usersOrganisations()
                }), animation: .default)
            }
        case let .navigationPathChanged(newValue):
            state.navigationPath = newValue
            return .none
        case let .usersOrganisationsReceived(.success(orgs)):
            state.isLoading = false
            state.usersOrganisations = orgs
            return .none
        case let .usersOrganisationsReceived(.failure(error)):
            state.isLoading = false
            state.errorMessage = error.friendlyMessage
            return .none
        case .joinTeamTapped:
            state.navigationPath.append(OrganisationsListRoute.joinTeam)
            return .none
        case let .teamSelected(team):
            state.selectedOrganisation = team
            state.navigationPath.append(OrganisationsListRoute.home)
            return .none
        default:
            return .none
        }
    },
    homeReducer.optional().pullback(
        state: \.homeStateCombined,
        action: /OrganisationsListAction.homeAction,
        environment: {
            HomeEnvironment(
                logout: $0.logout,
                clearAuthSession: $0.clearAuthSession,
                delay: { _ in },
                organisationTeamMembersClient: $0.organisationTeamMembersClient
            )
        }
    ),
    joinOrganisationReducer.optional().pullback(
        state: \.joinOrganisationStateCombined,
        action: /OrganisationsListAction.joinOrganisationAction,
        environment: { _ in
            JoinOrganisationEnvironment()
        }
    )
)
