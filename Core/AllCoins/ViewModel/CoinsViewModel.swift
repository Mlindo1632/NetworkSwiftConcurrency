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
        Task { try await fetchCryptoCoins() }
    }
    
    func fetchCryptoCoins() async throws {
        let fetchedCoins = try await service.fetchCryptoCoins()
        await MainActor.run {
            self.coins = fetchedCoins
        }
    }

    
    func fetchCoins() {
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
