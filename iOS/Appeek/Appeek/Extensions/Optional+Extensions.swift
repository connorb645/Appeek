//
//  Optional+Extensions.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

extension Optional: RawRepresentable where Wrapped: Codable {
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
