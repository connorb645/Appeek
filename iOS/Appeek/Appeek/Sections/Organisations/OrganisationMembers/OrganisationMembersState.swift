//
//  OrganisationMembersState.swift
//  Appeek
//
//  Created by Connor Black on 20/08/2022.
//

import Foundation

struct OrganisationMembersStateWithRoute: Equatable {
    var state: OrganisationMembersState
    var route: AppRoute
    
    static let preview = Self(state: OrganisationMembersState.preview,
                              route: .home(.init()))
}

struct OrganisationMembersState: Equatable {
    var homeRoute: HomeState.Route?
    var selectedOrganisation: Organisation
    var errorMessage: String? = nil
    var isLoading: Bool = false
    
    static let preview = Self(selectedOrganisation: .init(id: .init(),
                                                          name: "",
                                                          createdAt: ""))
}
