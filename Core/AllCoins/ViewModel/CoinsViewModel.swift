//
//  CoinsViewModel.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/16.
//

// When background thread is done ie. fetching info from a server, it needs to update the MAIN thread. Then the main thread will update the UI

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [CoinModel]()
    @Published var errorMessage: String?
    
     private let service = CoinDataService()
    
    init() {
        //fetchPrice(coin: "bitcoin", currency: "zar")
        fetchCoins()
    }
    
    func fetchCoins() {
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                self.coins = coins ?? []
//            }
//        }
        
        service.fetchCoinsWithResult {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
