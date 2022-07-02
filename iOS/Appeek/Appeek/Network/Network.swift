//
//  Network.swift
//  Appeek
//
//  Created by Connor Black on 02/07/2022.
//

import Foundation

struct Network {
    typealias StatusCodeAndData = (statusCode: Int, data: Data)
    
    private let urlSession: URLSession
    private let jsonSerializer: JsonSerializer
    
    init(urlSession: URLSession = URLSession.shared,
         jsonSerializer: JsonSerializer = JsonSerializer()) {
        self.urlSession = urlSession
        self.jsonSerializer = jsonSerializer
    }
    
    func get<ResponseType: Codable>(_ endPoint: Endpoint,
                                    bearerToken: String?) async throws -> ResponseType {
        let request = try RequestType.supabase(bearerToken: bearerToken).request(for: endPoint)
        let statusCodeAndData = try await perform(request)
        
        let successfulCodeRange = 200..<300
        
        if !successfulCodeRange.contains(statusCodeAndData.statusCode) {
            let unsuccessfulResponse: ServerError = try jsonSerializer.decode(data: statusCodeAndData.data)
            throw unsuccessfulResponse
        }
        
        let successfulResponse: ResponseType = try jsonSerializer.decode(data: statusCodeAndData.data)
        
        return successfulResponse
    }
    
    private func perform(_ request: URLRequest) async throws -> StatusCodeAndData {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseParse
        }
        
        guard !data.isEmpty else {
            throw NetworkError.emptyResponse
        }
        
        let statusCode = httpResponse.statusCode
        
        return (statusCode, data)
    }
    
    private func debugPrint(_ data: Data) {
        #if DEBUG
        print(String(data: data, encoding: .utf8) ?? "Couldn't parse Data as String")
        #endif
    }
}
