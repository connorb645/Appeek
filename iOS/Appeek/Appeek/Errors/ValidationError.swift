//
//  ValidationError.swift
//  Appeek
//
//  Created by Connor Black on 28/06/2022.
//

import Foundation

enum ValidationError: AppeekError {
    case passwordsDontMatch,
         emailAddressRequired,
         passwordRequired,
         passwordConfirmationRequired
    var friendlyMessage: String {
        switch self {
        case .passwordsDontMatch:
            return "The passwords you have entered don't match"
        case .emailAddressRequired:
            return "Your email address is required"
        case .passwordRequired:
            return "Your password is required"
        case .passwordConfirmationRequired:
            return "You must confirm your password"
        }
    }
}
