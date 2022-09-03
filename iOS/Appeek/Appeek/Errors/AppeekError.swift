//
//  AppeekError.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

protocol FriendlyMessagable {
    var friendlyMessage: String { get }
}

extension Error {
    func equals(_ error: Error) -> Bool {
        type(of: self) == type(of: error) &&
        self.localizedDescription == error.localizedDescription
    }
}

// MARK: - AppeekError

enum AppeekError: Error, Equatable, FriendlyMessagable {
    case standard(Error)
    case unknown
    case apiConfigError(APIConfigError)
    case networkError(NetworkError)
    case validationError(ValidationError)
    case jsonSerializaionError(JsonSerializerError)
    case noAuthSession
    
    var friendlyMessage: String {
        switch self {
        case .standard(let error):
            return "\(error.localizedDescription)"
        case .unknown:
            return "Unknown Error"
        case .apiConfigError(let apiConfigError):
            return apiConfigError.friendlyMessage
        case .networkError(let networkError):
            return networkError.friendlyMessage
        case .validationError(let validationError):
            return validationError.friendlyMessage
        case .jsonSerializaionError(let jsonSerializerError):
            return jsonSerializerError.friendlyMessage
        case .noAuthSession:
            return "No user is currently logged in"
        }
    }
    
    static func == (lhs: AppeekError, rhs: AppeekError) -> Bool {
        switch (lhs, rhs) {
        case (.standard(let lhsError),
              .standard(let rhsError)):
            return lhsError.equals(rhsError)
        case (.unknown,
              .unknown):
            return true
        case (.apiConfigError(let lhsError),
              .apiConfigError(let rhsError)):
            return lhsError == rhsError
        case (.networkError(let lhsError),
              .networkError(let rhsError)):
            return lhsError == rhsError
        case (.validationError(let lhsError),
              .validationError(let rhsError)):
            return lhsError == rhsError
        case (.jsonSerializaionError(let lhsError),
              .jsonSerializaionError(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

// MARK: - APIConfigError

enum APIConfigError: Equatable, FriendlyMessagable {
    case invalidUrl
    
    var friendlyMessage: String {
        switch self {
        case .invalidUrl:
            return "Unable to parse the provided String as a URL"
        }
    }
    
    static func == (lhs: APIConfigError, rhs: APIConfigError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        }
    }
}

// MARK: - NetworkError

enum NetworkError: Equatable, FriendlyMessagable {
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
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noUserId, .noUserId):
            return true
        case (.noAccessToken, .noAccessToken):
            return true
        case (.noSession, .noSession):
            return true
        case (.httpResponseParse, .httpResponseParse):
            return true
        case (.emptyResponse, .emptyResponse):
            return true
        case (.stringToUrlParse, .stringToUrlParse):
            return true
        case (.serverError(let lhsMessage, let lhsCode, let lhsDetails),
              .serverError(let rhsMessage, let rhsCode, let rhsDetails)):
            return lhsMessage == rhsMessage
                   && lhsCode == rhsCode
                   && lhsDetails == rhsDetails
        default:
            return false
        }
    }
}

// MARK: - ValidationError

enum ValidationError: Equatable, FriendlyMessagable {
    case passwordsDontMatch,
         emailAddressRequired,
         passwordRequired,
         passwordConfirmationRequired,
         firstNameRequired,
         lastNameRequired
    
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
        case .firstNameRequired:
            return "You must enter your first name"
        case .lastNameRequired:
            return "You must enter your last name"
        }
    }
    
    static func == (lhs: ValidationError, rhs: ValidationError) -> Bool {
        switch (lhs, rhs) {
        case (.passwordsDontMatch, .passwordsDontMatch):
            return true
        case (.emailAddressRequired, .emailAddressRequired):
            return true
        case (.passwordRequired, .passwordRequired):
            return true
        case (.passwordConfirmationRequired, .passwordConfirmationRequired):
            return true
        default:
            return false
        }
    }
}

// MARK: - JsonSerializerError

enum JsonSerializerError: Equatable, FriendlyMessagable {
    case decodingFailed(error: Error)
    case encodingFailed(error: Error)
    case jsonRepresentationFailed(error: Error)
    
    var friendlyMessage: String {
        switch self {
        case .decodingFailed:
            return "Unable to decode response"
        case .encodingFailed:
            return "Unable to encode data"
        case .jsonRepresentationFailed:
            return "Unable to represent as json"
        }
    }
        
    static func == (lhs: JsonSerializerError, rhs: JsonSerializerError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingFailed(let lhsError),
              .decodingFailed(let rhsError)):
            return lhsError.equals(rhsError)
        case (.encodingFailed(let lhsError),
              .encodingFailed(let rhsError)):
            return lhsError.equals(rhsError)
        case (.jsonRepresentationFailed(let lhsError),
              .jsonRepresentationFailed(let rhsError)):
            return lhsError.equals(rhsError)
        default:
            return false
        }
    }
}
