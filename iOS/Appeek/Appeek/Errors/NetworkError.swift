//
//  NetworkError.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

enum NetworkError: AppeekError {
    case noUserId, noAccessToken, noSession, httpResponseParse, emptyResponse, stringToUrlParse
    case serverError(message: String, code: String?, details: String?)
    var friendlyMessage: String {
        switch self {
        case .noUserId:
            return "No user id returned"
        case .noAccessToken:
            return "No access token returned"
        case .noSession:
            return "No session returned"
        case .httpResponseParse:
            return "Unexpected response type"
        case .emptyResponse:
            return "Empty response returned"
        case .stringToUrlParse:
            return "Request to invalid URL was attempted"
        case .serverError(let message, let code, let details):
            return "Server error with code: \(code ?? "No Code"). Message: \(message). Details: \(details ?? "No Details")"
        }
    }
}
