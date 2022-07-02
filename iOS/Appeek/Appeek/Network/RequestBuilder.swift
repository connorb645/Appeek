//
//  RequestBuilder.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

class RequestBuilder {
    var request: URLRequest
    
    init(endpoint: Endpoint,
         urlBuilder: URLBuilder = URLBuilder()) throws {
        let url = try urlBuilder.build(endpoint: endpoint)
        request = URLRequest(url: url)
    }
    
    func build() -> URLRequest {
        return self.request
    }
    
    func addHeader(_ headerField: HeaderField) -> RequestBuilder {
        self.request.addValue(headerField.value.value,
                              forHTTPHeaderField: headerField.key.value)
        return self
    }
    
    func addHttpMethod(_ method: HTTPMethod) -> RequestBuilder {
        self.request.httpMethod = method.rawValue
        return self
    }
}
