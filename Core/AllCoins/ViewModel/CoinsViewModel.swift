//
//  CoinsViewModel.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/16.
//

// When background thread is done ie. fetching infofrom a server, it needs to update the MAIN thread. Then the main thread will update the UI

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    
     private let service = CoinDataService()
    
    init() {
        fetchPrice(coin: "bitcoin", currency: "zar")
    }
    
    func fetchPrice(coin: String, currency: String)  {
        service.fetchPrice(coin: coin, currency: currency) { priceFromService in
            DispatchQueue.main.async {
                self.price = "R\(priceFromService)"
                self.coin = coin
            }
        }
    }
}
