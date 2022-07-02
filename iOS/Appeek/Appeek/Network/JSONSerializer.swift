//
//  JSONSerializer.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct JsonSerializer {
    
    func decode<T>(data: Data) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(T.self, from: data)
        } catch (let error) {
            throw JsonSerializerError.decodingFailed(error: error)
        }
    }
    
    func encode<T>(object: T) throws -> Data where T : Encodable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            return try encoder.encode(object)
        } catch (let error) {
            throw JsonSerializerError.encodingFailed(error: error)
        }
    }
    
    func jsonRepresentation<T>(object: T) throws -> [String : Any] where T : Decodable, T : Encodable {
        do {
            let paramsData = try encode(object: object)
            guard let params = try JSONSerialization.jsonObject(with: paramsData, options: []) as? [String: Any] else {
                throw JsonSerializerError.jsonRepresentationFailed(error: nil)
            }
            
            return params
        } catch (let error) {
            throw JsonSerializerError.jsonRepresentationFailed(error: error)
        }
    }
}
