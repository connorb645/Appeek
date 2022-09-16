//
//  OrganisationMembersAction.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum OrganisationMembersAction: Equatable {
    case onAppear
    case fetchFinished(TaskResult<OrganisationTeamMembersClient.FetchResponse>)
    case navigationPathChanged(NavigationPath)
    case dismissTapped
    case inviteTeamMemberTapped
}
