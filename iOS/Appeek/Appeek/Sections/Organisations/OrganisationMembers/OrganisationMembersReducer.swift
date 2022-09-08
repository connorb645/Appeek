//
//  OrganisationMembersReducer.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias OrganisationMembersReducer = Reducer<
    OrganisationMembersStateCombined,
    OrganisationMembersAction,
    OrganisationMembersEnvironment
>

let organisationMembersReducer = OrganisationMembersReducer { state, action, environment in
    switch action {
    case .onAppear:
        return .run { [state] send in
            await send(
                .teamMembersFetchFinished(
                    TaskResult { try await environment.fetchTeamMembersForOrganisation(state.selectedOrganisaion.id) }
                ),
                animation: .default
            )
        }
    case let .teamMembersFetchFinished(.success(members)):
        state.viewState.teamMembers = members
        state.viewState.isLoading = false
        return .none
    case let .teamMembersFetchFinished(.failure(error)):
        state.viewState.isLoading = false
        state.viewState.errorMessage = error.friendlyMessage
        return .none
    }
}
