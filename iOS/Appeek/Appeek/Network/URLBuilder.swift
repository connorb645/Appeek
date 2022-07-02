//
//  URLBuilder.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct URLBuilder {
    func build(endpoint: Endpoint,
               baseUrl: String = EnvironmentKey.supabaseBaseUrl.value) throws -> URL {
        let string = "\(baseUrl)\(endpoint.path)"
        print(string)
        guard let url = URL(string: "\(baseUrl)\(endpoint.path)") else {
            throw NetworkError.stringToUrlParse
        }
        
        return url
    }
}
