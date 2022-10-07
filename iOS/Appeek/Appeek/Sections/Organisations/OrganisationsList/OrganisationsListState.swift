//
//  OrganisationsListState.swift
//  Appeek
//
//  Created by Connor Black on 02/10/2022.
//

import Foundation
import SwiftUI

struct OrganisationsListState: Equatable {
    
    var homeStateCombined: HomeStateCombined? {
        get {
            guard let selectedOrganisation = selectedOrganisation else {
                return nil
            }
            return HomeStateCombined(
                viewState: homeState,
                navigationPath: navigationPath,
                selectedOrganisation: selectedOrganisation
            )
        }
        set {
            if let newValue = newValue {
                self.navigationPath = newValue.navigationPath
            }
            self._homeState = newValue?.viewState
            self.selectedOrganisation = newValue?.selectedOrganisation
        }
    }
    
    private var _homeState: HomeState?
    private var homeState: HomeState {
        get {
            _homeState ?? .init()
        }
    }
    
    var navigationPath: NavigationPath = .init()
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var usersOrganisations: [Organisation] = []
    var selectedOrganisation: Organisation?
    
    static let preview = Self()
}
