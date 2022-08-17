//
//  HomeState.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation

struct HomeStateWithRoute: Equatable {
    var state: HomeState
    var route: AppRoute
    
    init(state: HomeState,
         route: AppRoute) {
        self.state = state
        self.route = route
    }
    
    static let preview = Self(state: HomeState.preview,
                              route: .home(.init()))
}

struct HomeState: Equatable {
    enum Route {
        case settings
    }
    
    var homeRoute: Route?
    var usersOrganisations: [Organisation] = []
    var selectedOrganisation: Organisation?
    var errorMessage: String?
    var isLoading: Bool = false
    
    static let preview = Self()
}
