//
//  HomeState.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import SwiftUI

struct HomeStateCombined: Equatable {
    var viewState: HomeState
    var navigationPath: NavigationPath
    var selectedOrganisation: Organisation
    
    var organisationTeamMembersStateCombined: OrganisationMembersStateCombined? {
        get {
            return OrganisationMembersStateCombined(
                viewState: organisationTeamMembersState,
                selectedOrganisaion: selectedOrganisation
            )
        }
        set {
            self._organisationTeamMembersState = newValue?.viewState
        }
    }
    
    var _organisationTeamMembersState: OrganisationMembersState?
    var organisationTeamMembersState: OrganisationMembersState {
        get {
            _organisationTeamMembersState ?? .init()
        }
    }
    
    var settingsStateCombined: SettingsStateCombined? {
        get {
            .init(viewState: settingsState,
                  navigationPath: navigationPath)
        }
        set {
            if let newValue = newValue {
                self.navigationPath = newValue.navigationPath
            }
            self._settingsState = newValue?.viewState
        }
    }
    
    var _settingsState: SettingsState?
    var settingsState: SettingsState {
        get {
            _settingsState ?? .init()
        }
    }
    
    static let preview = Self(
        viewState: HomeState.preview,
        navigationPath: .init(),
        selectedOrganisation: .init(
            id: .init(),
            name: "",
            createdAt: ""
        )
    )
}

struct HomeState: Equatable {
    enum Route: Equatable {
        case settings
        case organisationMembersList
    }
    
    var route: Route?
    var errorMessage: String?
    var isLoading: Bool = false
    
    static let preview = Self()
}
