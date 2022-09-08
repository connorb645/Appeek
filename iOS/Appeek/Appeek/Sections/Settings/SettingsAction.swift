//
//  SettingsAction.swift
//  Appeek
//
//  Created by Connor Black on 18/08/2022.
//

import Foundation
import ComposableArchitecture

enum SettingsAction: Equatable {
    case logoutTapped
    case logoutResponseReceived(TaskResult<Void>)
    case loggedOut
    case dismissScreenTapped
    
    static func == (lhs: SettingsAction, rhs: SettingsAction) -> Bool {
        switch (lhs, rhs) {
        case (.logoutTapped, .logoutTapped):
            return true
        case (.logoutResponseReceived, .logoutResponseReceived):
            return true
        case (.loggedOut, .loggedOut):
            return true
        case (.dismissScreenTapped, .dismissScreenTapped):
            return true
        default:
            return false
        }
    }
}
