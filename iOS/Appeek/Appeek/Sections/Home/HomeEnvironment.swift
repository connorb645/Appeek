//
//  HomeEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture

struct HomeEnvironment {
    var logout: () async throws -> Void
    var clearAuthSession: () -> Void
    var usersOrganisations: () async throws -> [Organisation]
    var delay: (TimeInterval) async -> Void
    var organisationTeamMembersClient: OrganisationTeamMembersClient
    
    static let preview = Self(logout: {},
                              clearAuthSession: {},
                              usersOrganisations: {[]},
                              delay: { _ in },
                              organisationTeamMembersClient: .preview)
}
