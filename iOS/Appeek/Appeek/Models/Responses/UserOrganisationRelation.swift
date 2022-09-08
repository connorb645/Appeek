//
//  UserOrganisationRelation.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct UserOrganisationRelation {
    let userId: UUID
    let organisationId: UUID
}

extension UserOrganisationRelation: Codable {
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case organisationId = "organisation_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(UUID.self, forKey: .userId)
        self.organisationId = try container.decode(UUID.self, forKey: .organisationId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(organisationId, forKey: .organisationId)
    }
}
