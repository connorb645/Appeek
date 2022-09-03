//
//  SettingsState.swift
//  Appeek
//
//  Created by Connor Black on 18/08/2022.
//

import Foundation

struct SettingsStateWithRoute: Equatable {
    var state: SettingsState
    var route: AppRoute
    
    static let preview = Self(state: SettingsState.preview,
                              route: .home(.init()))
}

struct SettingsState: Equatable {
    var homeRoute: HomeState.Route?
    var isLoading: Bool = false
    var errorMessage: String?
    
    static let preview = Self()
}
