//
//  JoinOrganisationReducer.swift
//  Appeek
//
//  Created by Connor Black on 09/10/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias JoinOrganisationReducer = Reducer<
    JoinOrganisationStateCombined,
    JoinOrganisationAction,
    JoinOrganisationEnvironment
>

let joinOrganisationReducer = JoinOrganisationReducer.combine(
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            state.viewState.teamIdentifier = "4ed3ebf7-a351-4108-8e01-8750f8b77132"
            return .none
        case .joinTeamTapped:
            return .none
        case let .teamIdentifierChanged(newIdentifier):
            state.viewState.teamIdentifier = newIdentifier
            return .none
        }
    }
)
