//
//  CoinModel.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/17.
//

import Foundation

struct CoinModel: Codable, Identifiable { // One coin of many so needs to be parsed as
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
