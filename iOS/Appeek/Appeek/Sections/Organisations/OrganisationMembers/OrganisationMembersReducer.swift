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
        return .none
    }
}
