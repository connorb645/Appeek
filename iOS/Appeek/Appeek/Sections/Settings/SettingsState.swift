//
//  SettingsState.swift
//  Appeek
//
//  Created by Connor Black on 18/08/2022.
//

import Foundation
import SwiftUI

struct SettingsStateCombined: Equatable {
    var viewState: SettingsState
    var navigationPath: NavigationPath
    
    static let preview = Self(viewState: SettingsState.preview,
                              navigationPath: .init())
}

struct SettingsState: Equatable {
    var isLoading: Bool = false
    var errorMessage: String?
    
    static let preview = Self()
}
