//
//  OrganisationsListAction.swift
//  Appeek
//
//  Created by Connor Black on 02/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum OrganisationsListAction: Equatable {
    case homeAction(HomeAction)
    
    case onAppear
    case navigationPathChanged(NavigationPath)
    case usersOrganisationsReceived(TaskResult<[Organisation]>)
    case joinTeamTapped
    case teamSelected(Organisation)
}
