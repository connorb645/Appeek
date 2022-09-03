//
//  SupabaseRequest.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation
//
//enum RequestType {
//    case supabase(bearerToken: String?)
//    
//    func request(for endpoint: Endpoint,
//                 httpMethod: HTTPMethod) throws -> URLRequest {
//        let requestBuilder =
//            try RequestBuilder(endpoint: endpoint)
//                .addHttpMethod(httpMethod)
//        
//        switch self {
//        case .supabase(let token):
//            return supabaseRequest(using: requestBuilder,
//                                   endpoint: endpoint,
//                                   bearerToken: token)
//        }
//    }
//    
//    private func supabaseRequest(using requestBuilder: RequestBuilder,
//                                 endpoint: Endpoint,
//                                 bearerToken: String?) -> URLRequest {
//        if let bearerToken {
//            return requestBuilder
//                .addHeader(.init(key: .contentType,
//                                 value: .applicationJson))
//                .addHeader(.init(key: .apiKey,
//                                 value: .key(EnvironmentKey.supabaseKey.value)))
//                .addHeader(.init(key: .authorization, value: .bearer(bearerToken)))
//                .addBody(endpoint.body())
//                .build()
//        } else {
//            return requestBuilder
//                .addHeader(.init(key: .contentType,
//                                 value: .applicationJson))
//                .addHeader(.init(key: .apiKey,
//                                 value: .key(EnvironmentKey.supabaseKey.value)))
//                .addBody(endpoint.body())
//                .build()
//        }
//    }
//}
