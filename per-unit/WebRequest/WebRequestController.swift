//
//  WebRequestController.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import Foundation

func getProductDetails() async throws -> ProductData {
//    let API_ENDPOINT = "https://api.groq.com/openai/v1/chat/completions"
    let API_ENDPOINT = "https://api.github.com/users/sallen0400"
    
    guard let url = URL(string: API_ENDPOINT) else {
        throw WebRequestError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//        throw WebRequestError.httpError(statusCode: response.statusCode)
        throw WebRequestError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ProductData.self, from: data)
    } catch {
        throw WebRequestError.invalidData
    }
}

enum WebRequestError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
//    case httpError(statusCode: Int)
//    case other(Error)
}

// REFERENCES
// https://www.youtube.com/watch?v=ERr0GXqILgc
