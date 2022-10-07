//
//  OrganisationMembersState.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation
import SwiftUI

struct OrganisationMembersStateCombined: Equatable {
    var viewState: OrganisationMembersState
    var selectedOrganisaion: Organisation
    
    static let preview = Self(viewState: OrganisationMembersState.preview,
                              selectedOrganisaion: Organisation.stubbed)
}

struct OrganisationMembersState: Equatable {
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var admins: [UserPublicDetails] = []
    var nonAdmins: [UserPublicDetails] = []
    var navigationPath: NavigationPath = .init()
    var isCurrentUserAdmin = false
    var currentUserId: UUID? = nil
        
    func dots(_ count: Int) -> String {
        let dotsArray = (0..<count).indices.map { _ in
            "\u{2022}"
        }
        
        return dotsArray.joined(separator: "")
    }
    
    static let preview = Self()
}
