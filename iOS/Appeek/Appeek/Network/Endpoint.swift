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
    case applicationJson
    case key(_ key: String)
    case bearer(_ token: String)
    
    var value: String {
        switch self {
        case .xWwwFormUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .applicationJson:
            return "application/json"
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
    case usersOrganisationRelationsForUser(_ userId: UUID)
    case usersOrganisationRelationsForOrganisation(_ organisationId: UUID)
    case organisations(ids: [UUID])
    case createUserPublicDetails
    case getUserPublicDetails(ids: [UUID])
    
    var path: String {
        switch self {
        case .usersOrganisationRelationsForUser,
             .usersOrganisationRelationsForOrganisation:
            return "\(prefix)/users_organisations"
        case .organisations:
            return "\(prefix)/organisations"
        case .createUserPublicDetails,
             .getUserPublicDetails:
            return "\(prefix)/user_public_details"
        }
    }
    
    var queryParams: [(key: String, value: String)]? {
        switch self {
        case .usersOrganisationRelationsForUser(let userId):
            return [("user_id","eq.\(userId)"),
                    ("select", "*")]
        case .usersOrganisationRelationsForOrganisation(let organisationId):
            return [("organisation_id","eq.\(organisationId)"),
                    ("select", "*")]
        case .organisations(let ids):
            return [("id","in.\(ids.path)"),
                    ("select", "*")]
        case .createUserPublicDetails:
            return nil
        case .getUserPublicDetails(let ids):
            return [("user_id","in.\(ids.path)"),
                    ("select", "*")]
        }
    }
    
    private var version: String { "v1" }
    
    private var prefix: String { "/rest/\(version)" }
}

extension Array where Element: CustomStringConvertible {
    var pathWithPercentEncoding: String {
        return self.path.stringByAddingPercentEncodingForRFC3986()
    }
    
    var path: String {
        var toReturn = "("
        self.enumerated().forEach { i, string in
            if i == 0 {
                toReturn.append("\"\(string)\"")
            } else {
                toReturn.append(",\"\(string)\"")
            }
        }
        toReturn.append(")")
        return toReturn
    }
}

extension String {
  func stringByAddingPercentEncodingForRFC3986() -> String {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
  }
}
