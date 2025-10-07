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
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
            case .empty:
                Text("No data")
            case .error(let error):
                Text(error.localizedDescription)
            case .complete(let data):
                List {
                    ForEach(data) { coin in
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
                    }
                }
            }
        }
        .navigationTitle("Coins")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
