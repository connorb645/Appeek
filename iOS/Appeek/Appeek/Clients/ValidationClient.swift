//
//  ValidationClient.swift
//  Appeek
//
//  Created by Connor Black on 19/07/2022.
//

import Foundation

typealias ValidationRequirement = (value: String,
                                   field: ValidationField)

protocol ValidationClientProtocol {
    func validate(_ requirement: ValidationRequirement) -> Bool
    var match: (String, String) -> Bool { get }
}

struct ValidationClient: ValidationClientProtocol {
    func validate(_ requirement: ValidationRequirement) -> Bool {
        switch requirement.field {
        case  .email:
            return !requirement.value.isEmpty
        case .password:
            return !requirement.value.isEmpty
        case .confirmPassword:
            return !requirement.value.isEmpty
        }
    }
    
    var match: (String, String) -> Bool = { $0 == $1 }
    
    static let live = Self()
}

enum ValidationField {
    case email, password, confirmPassword
}
