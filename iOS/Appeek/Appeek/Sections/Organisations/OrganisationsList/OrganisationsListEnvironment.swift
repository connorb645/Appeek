//
//  OrganisationsListEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 02/10/2022.
//

import Foundation
import ComposableArchitecture

struct OrganisationsListEnvironment {
    var usersOrganisations: () async throws -> [Organisation]
    var logout: () async throws -> Void
    var clearAuthSession: () -> Void
    var delay: (TimeInterval) async -> Void
    var organisationTeamMembersClient: OrganisationTeamMembersClient
    
    static let preview = Self(
        usersOrganisations: { [] },
        logout: {  },
        clearAuthSession: {  },
        delay: { _ in },
        organisationTeamMembersClient: .preview
    )
}
