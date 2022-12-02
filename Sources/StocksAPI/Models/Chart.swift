//
//  Chart.swift
//  
//
//  Created by Joao Gripp on 01/12/22.
//

import Foundation

public struct ChartData: Decodable {
    
    public let meta: ChartMeta
    public let indicators: [Indicator]
    
    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorsKeys: CodingKey {
        case quote
    }
    
    enum QuoteKeys: CodingKey {
        case close
        case high
        case low
        case open
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        meta = try container.decode(ChartMeta.self, forKey: .meta)
        
        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        
        if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self)  {
            
            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            
            self.indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard
                    let open = opens[offset],
                    let close = closes[offset],
                    let high = highs[offset],
                    let low = lows[offset]
                else { return nil }
                
                return .init(timestamp: timestamp, open: open, high: high, low: low, close: close)
            }
            
        } else {
            self.indicators = []
        }
        
    }
    
    public init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }
}

public struct ChartMeta: Decodable {
    
    public let currency: String
    public let symbol: String
    public let regularMarketPrice: Double?
    public let previousClose: Double?
    public let gmtOffset: Int
    public let regularTradingPeriodStartDate: Date
    public let regularTradingPeriodEndDate: Date
    
    enum CodingKeys: CodingKey {
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtoffset
        case currentTradingPeriod
    }
    
    enum CurrentTradingKeys: CodingKey {
        case pre
        case regular
        case post
    }
    
    enum TradingPeriodKeys: CodingKey {
        case start
        case end
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.currency           = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol             = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        self.previousClose      = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        self.gmtOffset          = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0
        
        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingKeys.self, forKey: .currentTradingPeriod)
        let regularTradingPeriodContainer = try? container.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regularMarketPrice)
        
        self.regularTradingPeriodStartDate = try  regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .start) ?? Date()
        self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decodeIfPresent(Date.self, forKey: .end) ?? Date()
        
        
        
    }
}

public struct Indicator: Codable {
    
    public let timestamp: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    
    public init(timestamp: Date, open: Double, high: Double, low: Double, close: Double) {
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }

}