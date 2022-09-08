//
//  OrganisationMembersEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import ComposableArchitecture

struct OrganisationMembersEnvironment {
    var fetchTeamMembersForOrganisation: (UUID) async throws -> [UserPublicDetails]
    
    static let preview = Self(fetchTeamMembersForOrganisation: { _ in [] })
}
