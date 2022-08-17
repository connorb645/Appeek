//
//  HomeAction.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation

enum HomeAction: Equatable {
    case onAppear
    case settingsTapped
    case usersOrganisationsReceived(Result<[Organisation], AppeekError>)
    case selectedOrganisationUpdated(Organisation?)
    case homeRouteChanged(HomeState.Route?)
//    case retrievedAuthSession(Result<AuthSession, AppeekError>)
}
