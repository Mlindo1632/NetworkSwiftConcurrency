//
//  CoinDataService.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/17.
//

import Foundation

protocol CoinDataServiceProtocol {
    func fetchCoins() async throws -> [CoinModel]
}

struct CoinDataService: CoinDataServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchCoins() async throws -> [CoinModel] {
        let endpoint = SecurePlistReader.readValue(key: "CoinGeckoEndpoint")!
        let response: [CoinModel] = try await networkManager.request(endpoint: endpoint,
                                                                   method: HTTPMethod.get,
                                                                   parameters: nil,
                                                                   headers: nil)
        return response
    }
}

// MARK: - Completion Handlers

extension CoinDataService {
    func fetchCoinsWithResult(completion: @escaping(Result<[CoinModel], CoinAPIError>) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=zar&order=market_cap_desc&per_page=3&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                 let coins = try JSONDecoder().decode([CoinModel].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode with \(error)") // print privately so we only know, user will be confused
                completion(.failure(.jsonParsingFailure))
            }
            guard let coins = try? JSONDecoder().decode([CoinModel].self, from: data) else {
                print("DEBUG: Failed to decode CoinsModel")
                return
            }
            
            completion(.success(coins))
            print("DEBUG: Coins decoded \(coins)")
        }
        .resume()
    }
    
    func fetchCoins(completion: @escaping([CoinModel]?, Error?) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=zar&order=market_cap_desc&per_page=3&page=1&sparkline=false&price_change_percentage=24h&locale=en"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            guard let coins = try? JSONDecoder().decode([CoinModel].self, from: data) else {
                print("DEBUG: Failed to decode CoinsModel")
                return
            }
            
            completion(coins, nil)
            print("DEBUG: Coins decoded \(coins)")
        }
        .resume()
    }
    
    func fetchPrice(coin: String, currency: String, completion: @escaping(Double) -> Void)  {
        print("\(Thread.current)")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=\(currency)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
           
                if let error = error {
                    print("DEBUG: Failed with error \(error.localizedDescription)") // If there is an error, we don't move foward
                    //  self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    //      self.errorMessage = "Bad HTTP Response"
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    //     self.errorMessage = "Failed to fetch with status code \(httpResponse)"
                    return
                }
            
            
            print("\(Thread.current)")
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else { return }
            guard let price = value[currency] else {
                print("Failed to parse value")
                return }
            
            print("DEBUG: Price in service \(price)")
            completion(price)
        }.resume()
    }
}
