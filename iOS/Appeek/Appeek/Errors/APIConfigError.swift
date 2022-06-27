//
//  APIConfigError.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

enum APIConfigError: AppeekError {
    case invalidUrl
    
    var friendlyMessage: String {
        switch self {
        case .invalidUrl:
            return "Unable to parse the provided String as a URL"
        }
    }
}
