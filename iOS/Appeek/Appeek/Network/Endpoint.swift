//
//  Endpoint.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct HeaderField {
    let key: HeaderFieldKey
    let value: HeaderFieldValue
}

enum HeaderFieldKey {
    case contentType
    case apiKey
    case authorization
    
    var value: String {
        switch self {
        case .contentType:
            return "Content-Type"
        case .apiKey:
            return "apiKey"
        case .authorization:
            return "Authorization"
        }
    }
}

enum HeaderFieldValue {
    case xWwwFormUrlEncoded
    case key(_ key: String)
    case bearer(_ token: String)
    
    var value: String {
        switch self {
        case .xWwwFormUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .key(let key):
            return key
        case .bearer(let token):
            return "Bearer \(token)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum Endpoint {
    case usersOrganisationRelations(_ userId: UUID)
    case organisations(ids: [UUID])
    
    var path: String {
        switch self {
        case .usersOrganisationRelations(let userId):
            return "\(prefix)/users_organisations?user_id=eq.\(userId)&select=*"
            
            //Don't know why this string can't parse to a URL... maybe we need a more involved solution... URLComponents?
        case .organisations(let organisationIds):
            return "\(prefix)/organisations?id=in.%28\"a50c3752-da8b-4099-9699-9c452f5baca2\",\"21aec15d-0442-46ef-b448-ca4e29b7b035\"%29&select=*"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .usersOrganisationRelations:
            return .get
        case .organisations:
            return .get
        }
    }
    
    private var version: String { "v1" }
    
    private var prefix: String { "/rest/\(version)" }
}

extension Array where Element: CustomStringConvertible {
    var path: String {
        var toReturn = "%28"
        self.enumerated().forEach { i, string in
            if i == 0 {
                toReturn.append("\"\(string)\"")
            } else {
                toReturn.append(",\"\(string)\"")
            }
        }
        toReturn.append("%29")
        return toReturn
    }
}
