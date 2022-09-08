//
//  HomeState.swift
//  Appeek
//
//  Created by Connor Black on 09/08/2022.
//

import Foundation
import SwiftUI

struct HomeState: Equatable {
    enum Route: Equatable {
        case settings
        case organisationMembersList
    }
    
    var organisationTeamMembersStateCombined: OrganisationMembersStateCombined? {
        get {
            guard let selectedOrganisation = self.selectedOrganisation else { return nil }
            return OrganisationMembersStateCombined(
                viewState: organisationTeamMembersState,
                selectedOrganisaion: selectedOrganisation
            )
        }
        set {
            self._organisationTeamMembersState = newValue?.viewState
        }
    }
    
    private var _organisationTeamMembersState: OrganisationMembersState?
    private var organisationTeamMembersState: OrganisationMembersState {
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
    
    private var _settingsState: SettingsState?
    private var settingsState: SettingsState {
        get {
            _settingsState ?? .init()
        }
    }
    
    var navigationPath: NavigationPath = .init()
    var route: Route?
    var usersOrganisations: [Organisation] = []
    var selectedOrganisation: Organisation?
    var errorMessage: String?
    var isLoading: Bool = false
    
    static let preview = Self()
}
