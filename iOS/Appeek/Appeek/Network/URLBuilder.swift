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
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = endpoint.path
        components.queryItems = endpoint.queryParams.map { .init(name: $0.key, value: $0.value) }
        guard let url = components.url else {
            throw AppeekError.networkError(.stringToUrlParse)
        }
        return url
    }
    func build(baseUrl: String = EnvironmentKey.supabaseBaseUrl.value) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        guard let url = components.url else {
            throw AppeekError.networkError(.stringToUrlParse)
        }
        return url
    }
    
    static let live = Self()
}
