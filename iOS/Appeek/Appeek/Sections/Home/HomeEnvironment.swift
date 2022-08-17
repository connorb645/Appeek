//
//  HomeEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture

struct HomeEnvironment {
    var clearAuthSession: () -> Void
    var usersOrganisations: () -> Effect<[Organisation], AppeekError>
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(clearAuthSession: AuthenticateClient.preview.clearAuthSession,
                              usersOrganisations: OrganisationClient.preview.usersOrganisations,
                              mainQueue: .immediate)
}
