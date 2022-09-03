//
//  UserDetails.swift
//  Appeek
//
//  Created by Connor Black on 22/08/2022.
//

import Foundation

public struct UserPublicDetails: Equatable, Codable, Hashable {
    let id: UUID
    let userId: UUID
    let firstName: String
    let lastName: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
    }
}

extension UserPublicDetails {
    
    public struct Creation: Codable, Hashable {
        let id: UUID
        let userId: UUID
        let firstName: String
        let lastName: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case userId = "user_id"
            case firstName = "first_name"
            case lastName = "last_name"
        }
        
        public init(id: UUID,
                    userId: UUID,
                    firstName: String,
                    lastName: String) {
            self.id = id
            self.userId = userId
            self.firstName = firstName
            self.lastName = lastName
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(UUID.self, forKey: .id)
            self.userId = try container.decode(UUID.self, forKey: .userId)
            self.firstName = try container.decode(String.self, forKey: .firstName)
            self.lastName = try container.decode(String.self, forKey: .lastName)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(userId, forKey: .userId)
            try container.encode(firstName, forKey: .firstName)
            try container.encode(lastName, forKey: .lastName)
        }
    }
    
}
