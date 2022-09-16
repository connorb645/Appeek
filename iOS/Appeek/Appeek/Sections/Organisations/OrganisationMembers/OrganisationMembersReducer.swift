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
        state.viewState.isLoading = true
        return .run { [state] send in
            await send(
                .fetchFinished(
                    TaskResult {
                        try await environment.organisationTeamMembersClient.fetch(
                            orgId: state.selectedOrganisaion.id
                        )
                    }
                ),
                animation: .default
            )
        }
    case let .fetchFinished(.success(result)):
        state.viewState.admins = result.admins
        state.viewState.nonAdmins = result.nonAdmins
        state.viewState.isCurrentUserAdmin = result.isCurrentUserAdmin
        state.viewState.currentUserId = result.currentUserId
        state.viewState.isLoading = false
        return .none
    case let .fetchFinished(.failure(error)):
        state.viewState.isLoading = false
        state.viewState.errorMessage = error.friendlyMessage
        return .none
    case let .navigationPathChanged(path):
        state.viewState.navigationPath = path
        return .none
    case .dismissTapped:
        return .none
    case .inviteTeamMemberTapped:
        return .none
    }
}
