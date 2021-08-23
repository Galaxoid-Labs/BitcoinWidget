//
//  BitcoinPrice.swift
//  BitcoinPrice
//
//  Created by Jacob Davis on 8/17/21.
//

import Foundation
import CloudKit

struct BitcoinPrice: Codable, Hashable, Identifiable {
    
    let id: String
    let price: Double
    let marketCap: Double
    let totalVolume: Double
    let priceChange24: Double
    let priceChangePercent24: Double
    let circulatingSupply: Double
    let allTimeHigh: Double
    let allTimeLow: Double
    
    let updatedAt: Date
    let createdAt: Date
    
    let recordId: String
    static let recordType: String = "BitcoinPrice"
    
    var isUp: Bool {
        priceChangePercent24 > Double.zero
    }
    
    func formattedPricePercentChange24() -> String {
        return priceChangePercent24.formatted(.number.precision(.fractionLength(2))) + "%"
    }
    
    func formattedPrice() -> String {
        return price.formatted(.currency(code: id).precision(.fractionLength(0...2)))
    }
    
    func formattedMarketCap() -> String {
        return marketCap.formatted(.currency(code: id).precision(.fractionLength(0...2)))
    }
    
    func formattedMarketCapAbv(currencyCode: String) -> String {
        return marketCap.formatCurrencyAbreviation(currencyCode: currencyCode)
    }
    
    func formattedVolume() -> String {
        return totalVolume.formatted(.currency(code: id).precision(.fractionLength(0...2)))
    }
    
    func formattedVolumeAbv(currencyCode: String) -> String {
        return totalVolume.formatCurrencyAbreviation(currencyCode: currencyCode)
    }
    
    static func placeHolder() -> BitcoinPrice {
        return BitcoinPrice(id: "usd", price: 0.0, marketCap: 0.0, totalVolume: 0.0,
                            priceChange24: 0.0, priceChangePercent24: 100.0, circulatingSupply: 0.0,
                            allTimeHigh: 0.0, allTimeLow: 0.0, updatedAt: .now,
                            createdAt: .now, recordId: "usd")
    }
    
}

extension BitcoinPrice {
    
    init?(record: CKRecord) {
        
        if record.recordType != BitcoinPrice.recordType { return nil }
        
        guard let price = record.object(forKey: "price") as? Double else { return nil }
        guard let marketCap = record.object(forKey: "marketCap") as? Double else { return nil }
        guard let totalVolume = record.object(forKey: "totalVolume") as? Double else { return nil }
        guard let priceChange24 = record.object(forKey: "priceChange24") as? Double else { return nil }
        guard let priceChangePercent24 = record.object(forKey: "priceChangePercent24") as? Double else { return nil }
        guard let circulatingSupply = record.object(forKey: "circulatingSupply") as? Double else { return nil }
        guard let allTimeHigh = record.object(forKey: "allTimeHigh") as? Double else { return nil }
        guard let allTimeLow = record.object(forKey: "allTimeLow") as? Double else { return nil }
        
        self.id = record.recordID.recordName
        self.price = price
        self.marketCap = marketCap
        self.totalVolume = totalVolume
        self.priceChange24 = priceChange24
        self.priceChangePercent24 = priceChangePercent24
        self.circulatingSupply = circulatingSupply
        self.allTimeHigh = allTimeHigh
        self.allTimeLow = allTimeLow
        
        self.recordId = record.recordID.recordName
        self.createdAt = record.creationDate ?? Date.now
        self.updatedAt = record.modificationDate ?? Date.now
    }
    
    func getCKRecord() -> CKRecord {
        
        let record = CKRecord(recordType: BitcoinPrice.recordType, recordID: CKRecord.ID.init(recordName: recordId))
        record.setValue(price, forKey: "price")
        record.setValue(marketCap, forKey: "marketCap")
        record.setValue(totalVolume, forKey: "totalVolume")
        record.setValue(priceChange24, forKey: "priceChange24")
        record.setValue(priceChangePercent24, forKey: "priceChangePercent24")
        record.setValue(circulatingSupply, forKey: "circulatingSupply")
        record.setValue(allTimeHigh, forKey: "allTimeHigh")
        record.setValue(allTimeLow, forKey: "allTimeLow")

        return record
    }

}
