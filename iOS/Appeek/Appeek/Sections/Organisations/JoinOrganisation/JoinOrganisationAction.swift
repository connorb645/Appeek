//
//  JoinOrganisationAction.swift
//  Appeek
//
//  Created by Connor Black on 09/10/2022.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum JoinOrganisationAction: Equatable {
    case onAppear
    case joinTeamTapped
    case teamIdentifierChanged(String)
}
