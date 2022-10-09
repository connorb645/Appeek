//
//  JoinOrganisationState.swift
//  Appeek
//
//  Created by Connor Black on 09/10/2022.
//

import Foundation
import SwiftUI

struct JoinOrganisationStateCombined: Equatable {
    var viewState: JoinOrganisationState
    var navigationPath: NavigationPath
}

struct JoinOrganisationState: Equatable {
    var teamIdentifier = ""
    var isLoading = false
}
