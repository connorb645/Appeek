//
//  ServerError.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct ServerError: AppeekError {
    var friendlyMessage: String {
        message ?? "No error message returned"
    }
    let message: String?
    let code: String?
    let details: String?
}

extension ServerError: Codable {
    
}
