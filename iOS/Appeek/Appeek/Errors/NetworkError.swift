//
//  NetworkError.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

enum NetworkError: AppeekError {
    case noUserId, noAccessToken, httpResponseParse, emptyResponse, stringToUrlParse
    var friendlyMessage: String {
        switch self {
        case .noUserId:
            return "No user id returned"
        case .noAccessToken:
            return "No access token returned"
        case .httpResponseParse:
            return "Unexpected response type"
        case .emptyResponse:
            return "Empty response returned"
        case .stringToUrlParse:
            return "Request to invalid URL was attempted"
        }
    }
}
