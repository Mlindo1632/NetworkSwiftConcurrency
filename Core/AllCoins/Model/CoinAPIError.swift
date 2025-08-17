//
//  CoinAPIError.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/17.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestDailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid data"
        case .jsonParsingFailure: return "Failed to parse JSON"
        case let .requestDailed(description): return "Request failed: \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code: \(statusCode)"
        case let .unknownError(error): return "An unknown error occured: \(error.localizedDescription)"
        }
    }
}
