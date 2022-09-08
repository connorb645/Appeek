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
    var fetchTeamMembersForOrganisation: (UUID) async throws -> [UserPublicDetails]
    
    static let preview = Self(logout: {},
                              clearAuthSession: {},
                              usersOrganisations: {[]},
                              delay: { _ in },
                              fetchTeamMembersForOrganisation: { _ in [] })
}
