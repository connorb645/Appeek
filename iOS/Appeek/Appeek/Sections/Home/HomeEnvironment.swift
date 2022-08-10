//
//  HomeEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture

struct HomeEnvironment {
    var clearAuthSession: (UserDefaults) -> Void
    var usersOrganisations: (UUID, String) -> Effect<[Organisation], AppeekError>
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    static let preview = Self(clearAuthSession: AuthenticateClient.live.clearAuthSession(from:),
                              usersOrganisations: OrganisationClient.live.usersOrganisations(_:bearerToken:),
                              mainQueue: .immediate)
}
