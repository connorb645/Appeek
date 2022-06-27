//
//  AuthSession.swift
//  Appeek
//
//  Created by Connor Black on 27/06/2022.
//

import Foundation

public struct AuthSession {
    let userId: String
    let accessToken: String
}

extension AuthSession: Codable { }

extension AuthSession: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(AuthSession.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return result
    }
}

extension Optional: RawRepresentable where Wrapped == AuthSession {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(AuthSession.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return result
    }
}
