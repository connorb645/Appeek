//
//  Error+Extensions.swift
//  Appeek
//
//  Created by Connor Black on 02/09/2022.
//

import Foundation

extension Error {
    var friendlyMessage: String {
        if let error = self as? AppeekError {
            return error.friendlyMessage
        } else {
            return AppeekError.unknown.friendlyMessage
        }
    }
}
