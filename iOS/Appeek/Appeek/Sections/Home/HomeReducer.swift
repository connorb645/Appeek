//
//  HomeReducer.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import ComposableArchitecture
import CasePaths

typealias HomeReducer = Reducer<
    HomeStateWithRoute,
    HomeAction,
    HomeEnvironment
>

let homeReducer = HomeReducer { state, action, environment in
    switch action {
    case .onAppear:
        return environment.usersOrganisations()
            .receive(on: environment.mainQueue)
            .catchToEffect(HomeAction.usersOrganisationsReceived)
    case .settingsTapped:
        state.state.homeRoute = .settings
        return .none
    case let .usersOrganisationsReceived(.success(organisations)):
        state.state.usersOrganisations = organisations
        return .none
    case let .usersOrganisationsReceived(.failure(error)):
        state.state.errorMessage = error.friendlyMessage
        return .none
    case let .selectedOrganisationUpdated(organisation):
        state.state.selectedOrganisation = organisation
        return .none
    case let .homeRouteChanged(route):
        state.state.homeRoute = route
        return .none
    }
}
