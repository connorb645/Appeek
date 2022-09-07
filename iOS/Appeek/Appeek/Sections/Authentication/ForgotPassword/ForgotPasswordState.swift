//
//  ForgotPasswordState.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import SwiftUI

struct ForgotPasswordStateCombined: Equatable {
    var viewState: ForgotPasswordState
    var navigationPath: NavigationPath
    
    static let preview = Self(viewState: ForgotPasswordState.preview,
                              navigationPath: .init())
}

struct ForgotPasswordState: Equatable {
    var errorMessage: String? = nil
    var isLoading: Bool = false
    var emailAddress: String = ""
    
    static let preview = Self()
}
