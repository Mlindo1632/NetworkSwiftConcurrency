//
//  CoinDataService.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/17.
//

import Foundation

class CoinDataService {
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
