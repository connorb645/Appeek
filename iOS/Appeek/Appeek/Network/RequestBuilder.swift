//
//  RequestBuilder.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

class RequestBuilder {
    var request: URLRequest
    let encoder: JSONEncoder
    
    init(endpoint: Endpoint,
         urlBuilder: URLBuilder = URLBuilder(),
         encoder: JSONEncoder = JSONEncoder()) throws {
        self.encoder = encoder
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
    
    func addBody(_ object: (any Encodable)?) -> RequestBuilder {
        if let unwrapped = object,
           let data = try? encoder.encode(unwrapped) {
            self.request.httpBody = data
        }
        return self
    }
}
