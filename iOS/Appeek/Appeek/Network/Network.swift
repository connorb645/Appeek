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
    
    init(urlSession: URLSession,
         jsonSerializer: JsonSerializer) {
        self.urlSession = urlSession
        self.jsonSerializer = jsonSerializer
    }
    
    func get<ResponseType: Codable>(_ endPoint: Endpoint,
                                    refreshMiddleware: Middleware,
                                    currentAuthSession: () throws -> AuthSession) async throws -> ResponseType {
        let accessToken = try currentAuthSession().accessToken
        let request = try RequestType.supabase(bearerToken: accessToken).request(for: endPoint)
        let statusCodeAndData = try await perform(request)
        
        let successfulCodeRange = 200..<300
        
        if !successfulCodeRange.contains(statusCodeAndData.statusCode) {
            let serverError: ServerError = try jsonSerializer.decode(data: statusCodeAndData.data)
            
            if serverError.code == "PGRST301" {
                try await refreshMiddleware.run()
                return try await get(endPoint,
                                     refreshMiddleware: refreshMiddleware,
                                     currentAuthSession: currentAuthSession)
            } else {
                throw AppeekError.networkError(.serverError(message: serverError.message,
                                                            code: serverError.code,
                                                            details: serverError.details))
            }
            
        }
        
        let successfulResponse: ResponseType = try jsonSerializer.decode(data: statusCodeAndData.data)
        
        return successfulResponse
    }
    
    private func perform(_ request: URLRequest) async throws -> StatusCodeAndData {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppeekError.networkError(.httpResponseParse)
        }
        
        guard !data.isEmpty else {
            throw AppeekError.networkError(.emptyResponse)
        }
        
        let statusCode = httpResponse.statusCode
        
        return (statusCode, data)
    }
    
    private func debugPrint(_ data: Data) {
        #if DEBUG
        print(String(data: data, encoding: .utf8) ?? "Couldn't parse Data as String")
        #endif
    }
    
    static let preview = Self(urlSession: .shared,
                              jsonSerializer: .init())
}

protocol Middleware {
    func run() async throws
}

struct RefreshMiddleware: Middleware {
    let userDefaults: UserDefaults
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let currentAuthSession: () throws -> AuthSession
    let refreshToken: () async throws -> AuthSession
    let persistAuthSession: (AuthSession) throws -> AuthSession
    
    func run() async throws {
        let newAuthSession = try await refreshToken()
        _ = try persistAuthSession(newAuthSession)
    }
    
    static let preview: RefreshMiddleware = Self.init(userDefaults: UserDefaults.standard,
                                                      decoder: JSONDecoder(),
                                                      encoder: JSONEncoder(),
                                                      currentAuthSession: {
        .init(userId: UUID(), accessToken: "", refreshToken: "")
    },
                                                      refreshToken: {
            .init(userId: UUID(), accessToken: "", refreshToken: "")
    },
                                                      persistAuthSession: { session in
        return .init(userId: UUID(), accessToken: "", refreshToken: "")
    })
}
