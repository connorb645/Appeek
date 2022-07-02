//
//  SupabaseRequest.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

enum RequestType {
    case supabase(bearerToken: String?)
    
    func request(for endpoint: Endpoint) throws -> URLRequest {
        let requestBuilder = try RequestBuilder(endpoint: endpoint)
        
        switch self {
        case .supabase(let token):
            return supabaseRequest(using: requestBuilder,
                                   endpoint: endpoint,
                                   bearerToken: token)
        }
    }
    
    private func supabaseRequest(using requestBuilder: RequestBuilder,
                                      endpoint: Endpoint,
                                      bearerToken: String?) -> URLRequest {
        if let bearerToken {
            return requestBuilder
                .addHttpMethod(endpoint.httpMethod)
                .addHeader(.init(key: .contentType,
                                 value: .xWwwFormUrlEncoded))
                .addHeader(.init(key: .apiKey,
                                 value: .key(EnvironmentKey.supabaseKey.value)))
                .addHeader(.init(key: .authorization, value: .bearer(bearerToken)))
                .build()
        } else {
            return requestBuilder
                .addHttpMethod(endpoint.httpMethod)
                .addHeader(.init(key: .contentType,
                                 value: .xWwwFormUrlEncoded))
                .addHeader(.init(key: .apiKey,
                                 value: .key(EnvironmentKey.supabaseKey.value)))
                .build()
        }
    }
}
