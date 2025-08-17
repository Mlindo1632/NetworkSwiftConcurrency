//
//  ContentView.swift
//  NetworkSwiftConcurrency
//
//  Created by Lindokuhle Khumalo on 2025/08/16.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
            List {
                ForEach(viewModel.coins) { coin in
                HStack(spacing: 12) {
                    Text("\(coin.marketCapRank)")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "heart.fill")
                    
                    VStack (alignment: .leading, spacing: 4) {
                        Text(coin.name).bold()
                            .fontWeight(.semibold)
                        
                        Text(coin.symbol.uppercased())
                    }
                }
                .font(.footnote)
            }
        }
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
