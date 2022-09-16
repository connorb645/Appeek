//
//  OrganisationMembersEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import ComposableArchitecture

struct OrganisationMembersEnvironment {
    var organisationTeamMembersClient: OrganisationTeamMembersClient
    
    static let preview = Self(organisationTeamMembersClient: .preview)
}
