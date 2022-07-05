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
        case .usersOrganisationRelations:
            return "\(prefix)/users_organisations"
        case .organisations:
            return "\(prefix)/organisations"
        }
    }
    
    var queryParams: [(key: String, value: String)] {
        switch self {
        case .usersOrganisationRelations(let userId):
            return [("user_id","eq.\(userId)"),
                    ("select", "*")]
        case .organisations(let ids):
            return [("id","in.\(ids.path)"),
                    ("select", "*")]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .usersOrganisationRelations, .organisations:
            return .get
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
