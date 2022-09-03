//
//  ForgotPasswordEnvironment.swift
//  Appeek
//
//  Created by Connor Black on 01/08/2022.
//

import Foundation
import ComposableArchitecture

struct ForgotPasswordEnvironment {
    var resetPassword: (String) async throws -> Void
    var validate: (ValidationRequirement) -> Bool
        
    static let preview = Self(resetPassword: SupabaseAPI.preview.resetPassword(email:),
                              validate: ValidationClient.preview.validate(_:))
}
