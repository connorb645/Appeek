//
//  OrganisationMembersState.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation

struct OrganisationMembersStateCombined: Equatable {
    var viewState: OrganisationMembersState
    var selectedOrganisaion: Organisation
    
    static let preview = Self(viewState: OrganisationMembersState.preview,
                              selectedOrganisaion: Organisation.stubbed)
}

struct OrganisationMembersState: Equatable {
    var homeRoute: HomeState.Route?
    var errorMessage: String? = nil
    var isLoading: Bool = false
    
    static let preview = Self()
}
