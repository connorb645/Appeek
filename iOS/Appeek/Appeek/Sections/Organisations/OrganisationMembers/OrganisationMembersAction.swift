//
//  OrganisationMembersAction.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import ComposableArchitecture

enum OrganisationMembersAction: Equatable {
    case onAppear
    case teamMembersFetchFinished(TaskResult<[UserPublicDetails]>)
}
