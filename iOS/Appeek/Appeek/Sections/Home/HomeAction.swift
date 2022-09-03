//
//  HomeAction.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture

enum HomeAction: Equatable {
    case settingsAction(SettingsAction)
    case organisationMembersAction(OrganisationMembersAction)
    
    case onAppear
    case goToSettingsTapped
    case usersOrganisationsReceived(TaskResult<[Organisation]>)
    case selectedOrganisationUpdated(Organisation?)
    case homeRouteChanged(HomeState.Route?)
    case goToTeamMembersListTapped
}
