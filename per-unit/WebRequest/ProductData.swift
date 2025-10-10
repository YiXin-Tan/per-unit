//
//  ProductData.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import Foundation

// Main response structure
struct ProductData: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String
}

struct Message: Codable {
    let role: String
    let content: String
    
    // Helper to decode the product info from the content JSON string
    func getProductInfo() throws -> ProductInfo {
        guard let data = content.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Invalid UTF-8")
            )
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ProductInfo.self, from: data)
    }
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
}

// The actual product information extracted
struct ProductInfo: Codable {
    let productName: String
    let price: Double
    let amount: Double
    let unit: String
}
