//
//  HomeAction.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum HomeAction: Equatable {
    case settingsAction(SettingsAction)
    case organisationMembersAction(OrganisationMembersAction)
    
    case onAppear
    case goToSettingsTapped
//    case usersOrganisationsReceived(TaskResult<[Organisation]>)
//    case selectedOrganisationUpdated(Organisation?)
    case homeRouteChanged(HomeState.Route?)
    case goToTeamMembersListTapped
//    case navigationPathChanged(NavigationPath)
    case sheetDismissalDelayEnded(loggedOut: Bool)
}
