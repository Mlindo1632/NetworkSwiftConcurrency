//
//  CoinsViewModel.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/16.
//

// When background thread is done ie. fetching info from a server, it needs to update the MAIN thread. Then the main thread will update the UI

import Foundation

@MainActor
class CoinsViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var loadingState: ContentLoadingState<[CoinModel]> = .loading
    
    private let service: CoinDataServiceProtocol
    
    init(service: CoinDataServiceProtocol = CoinDataService(networkManager: NetworkManager.shared)) {
        self.service = service
        Task { await loadCoins() }
    }
    
    func loadCoins() async {
        do {
            try await Task.sleep(nanoseconds: 6_000_000_000)
            
            let fetchedCoins = try await service.fetchCoins()
            self.loadingState = fetchedCoins.isEmpty ? .empty : .complete(data: fetchedCoins)
        } catch {
            self.loadingState = .error(error)
        }
    }
}

    
//    func fetchCoins() {
//        service.fetchCoinsWithResult {[weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let coins):
//                    self?.coins = coins
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
//}
