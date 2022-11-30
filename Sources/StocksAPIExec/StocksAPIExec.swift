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
        print(StocksAPI().text)
    }
}
