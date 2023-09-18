//
//  URLSession++.swift
//  SwiftUIDemo
//
//  Created by Lurich on 2023/9/18.
//

import Foundation

extension URLSession {
    static var imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        return URLSession(configuration: config)
    }()
}

extension URLSession {
    enum APIError: Error {
        case invalidURL
        case invalidData
        case invalidCode(Int)
    }
    
    
    func data(for urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await self.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse else { throw APIError.invalidURL }
        guard 200...299 ~= response.statusCode else {
            assertionFailure(String(data: data, encoding: .utf8) ?? "")
            throw APIError.invalidCode(response.statusCode)
            
        }
        return data
    }
}

extension URLCache {
    static let imageCache: URLCache = {
        URLCache(memoryCapacity: 20 * 1024 * 1024,
                 diskCapacity: 30 * 1024 * 1024,
                 directory: FileManager.default.temporaryDirectory)
    }()
}
