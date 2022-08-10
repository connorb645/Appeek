//
//  HomeState.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation

struct HomeStateWithRouteAndSession: Equatable {
    var state: HomeState
    var route: AppRoute
    var currentSession: AuthSession
    
    static let preview = Self(state: HomeState.preview,
                              route: .home(.init()),
                              currentSession: .init(userId: .init(),
                                                    accessToken: "randomaccesstoken",
                                                    refreshToken: "randomrefreshtoken"))
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
