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
    
    static let preview = Self(logout: {},
                              clearAuthSession: {},
                              usersOrganisations: {[]})
}