//
//  StocksAPIExec.swift
//  
//
//  Created by Joao Gripp on 30/11/22.
//

import Foundation
import StocksAPI

@main
struct StocksAPIExec {
    
    static func main() async {
        
//        let (data, _) = try! await URLSession.shared.data(from: URL(string: "https://query1.finance.yahoo.com/v7/finance/quote?symbols=AAPL,MSFT,GOOG,TSLA")!)
//
//        let quoteResponse = try! JSONDecoder().decode(QuoteResponse.self, from: data)
//
//        print(quoteResponse)
        
        let (searchData, _) = try! await URLSession.shared.data(from: URL(string: "https://query1.finance.yahoo.com/v1/finance/search?q=Tesla")!)
        
        let searchResponse = try! JSONDecoder().decode(SearchTickerResponse.self, from: searchData)
        
        print(searchResponse)
        
        
//        print(StocksAPI().text)
    }
}
