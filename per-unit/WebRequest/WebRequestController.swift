//
//  WebRequestController.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import Foundation
import SwiftUI

func getProductData(rawText: String) async throws -> ProductData {
    let API_ENDPOINT = "https://api.groq.com/openai/v1/chat/completions"
    let API_KEY = "XXXXXX"
    
    guard let url = URL(string: API_ENDPOINT) else {
        throw WebRequestError.invalidURL
    }
    
    // Create the request body
    let requestBody: [String: Any] = [
        "model": "moonshotai/kimi-k2-instruct-0905",
        "messages": [
            [
                "role": "system",
                "content": "Extract product information from the raw price label text."
            ],
            [
                "role": "user",
                "content": rawText
            ]
        ],
        "response_format": [
            "type": "json_schema",
            "json_schema": [
                "name": "product",
                "schema": [
                    "type": "object",
                    "properties": [
                        "product_name": ["type": "string"],
                        "price": ["type": "number"],
                        "amount": ["type": "number"],
                        "unit": [
                            "type": "string",
                            "enum": ["g", "kg", "ml", "l", "ea"]
                        ]
                    ],
                    "required": ["product_name", "price", "amount", "unit"],
                    "additionalProperties": false
                ]
            ]
        ]
    ]
    
    // Convert request body to JSON data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
        throw WebRequestError.invalidData
    }
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(API_KEY)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        if let httpResponse = response as? HTTPURLResponse {
            throw WebRequestError.httpError(statusCode: httpResponse.statusCode)
        }
        throw WebRequestError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        print("Decoded data: \(try decoder.decode(ProductData.self, from: data))")
        return try decoder.decode(ProductData.self, from: data)
    } catch {
        print("Decoding error: \(error)")
        throw WebRequestError.invalidData
    }
}

func joinStringsWithNewlines(_ input: [String]) -> String {
    return input.joined(separator: "\n")
}

enum WebRequestError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case httpError(statusCode: Int)
}

// REFERENCES
// https://www.youtube.com/watch?v=ERr0GXqILgc
