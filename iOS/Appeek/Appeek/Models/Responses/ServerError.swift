//
//  ServerError.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct ServerError {
    let message: String
    let code: String?
    let details: String?
}

extension ServerError: Codable { }
