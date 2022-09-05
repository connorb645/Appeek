//
//  HomeState.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import SwiftUI

//struct HomeStateWithRoute: Equatable {
//
//    var settingsState: SettingsStateWithRoute {
//        get {
//            .init(state: .init(homeRoute: state.homeRoute),
//                  route: route)
//        }
//        set {
//            state.homeRoute = newValue.state.homeRoute
//            route = newValue.route
//        }
//    }
//
//    var organisationMembersState: OrganisationMembersStateWithRoute {
//        get {
//            guard let selectedOrg = state.selectedOrganisation else {
//                fatalError("Selected Organisation should not be nil at this point.")
//            }
//            return .init(state: .init(homeRoute: state.homeRoute,
//                                      selectedOrganisation: selectedOrg),
//                         route: route)
//        }
//        set {
////            state.homeRoute = newValue.state.homeRoute
//            route = newValue.route
//        }
//    }
//
//    var state: HomeState
//    var route: AppRoute
//
//    init(state: HomeState,
//         route: AppRoute) {
//        self.state = state
//        self.route = route
//    }
//
//    static let preview = Self(state: HomeState.preview,
//                              route: .home(.init()))
//}

struct HomeState: Equatable {
    enum Route: Equatable {
        case settings
        case organisationMembersList
    }
    
//    var homeRoute: Route?
    var navigationPath: NavigationPath = .init()
    var route: Route?
    var usersOrganisations: [Organisation] = []
    var selectedOrganisation: Organisation?
    var errorMessage: String?
    var isLoading: Bool = false
    
    static let preview = Self()
}
