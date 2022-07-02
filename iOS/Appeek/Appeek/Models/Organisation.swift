//
//  Organisation.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

public struct Organisation {
    let id: UUID
    let name: String
    let createdAt: String
}

extension Organisation: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name = "name"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(name, forKey: .name)
    }
}

extension Organisation: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Self.self, from: data)
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
