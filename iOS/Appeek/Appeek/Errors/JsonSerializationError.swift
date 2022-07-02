//
//  JsonSerializationError.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

enum JsonSerializerError: Error, Equatable {
    
    case decodingFailed(error: Error?)
    case encodingFailed(error: Error?)
    case jsonRepresentationFailed(error: Error?)
    
    static func == (lhs: JsonSerializerError, rhs: JsonSerializerError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingFailed(_), .decodingFailed(_)):
            return true
        case (.encodingFailed(_), .encodingFailed(_)):
            return true
        case (.jsonRepresentationFailed(_), .jsonRepresentationFailed(_)):
            return true
        default:
            return false
        }
    }
}
