//
//  SettingsEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 18/08/2022.
//

import Foundation
import ComposableArchitecture

struct SettingsEnvironment {
    var logout: () async throws -> Void
    var clearAuthSession: () -> Void
    var delay: (TimeInterval) async -> Void
        
    static let preview = Self(logout: {},
                              clearAuthSession: {},
                              delay: delay(for:))
}
