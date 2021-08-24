//
//  BitcoinStats.swift
//  BitcoinStats
//
//  Created by Jacob Davis on 8/17/21.
//

import Foundation
import CloudKit

struct BitcoinStats: Codable, Hashable, Identifiable {
    
    let id: String
    
    let blockHeight: Int64
    let blockSize: Int64
    let difficulty: Int64
    let hashRate: Double
    
    let updatedAt: Date
    let createdAt: Date
    
    let recordId: String
    static let recordType: String = "BitcoinStats"
    
    func formattedBlockHeight() -> String {
        return blockHeight.formatted()
    }
    
    func formattedBlockSize() -> String {
        return ByteCountFormatter.string(fromByteCount: (blockSize*8)/1024, countStyle: .file) // ??? not sure if this is the right calc
    }
    
    func formattedHashRate() -> String {
        return (hashRate/1000).formatAbreviation()
    }
    func formattedDifficulty() -> String {
        return Double(integerLiteral: difficulty).formatAbreviation()
    }
    
    static func placeHolder() -> BitcoinStats {
        return BitcoinStats(id: "BitcoinStats", blockHeight: 0, blockSize: 0, difficulty: 0, hashRate: 0.0, updatedAt: .now, createdAt: .now, recordId: "BitcoinStats")
    }
}

extension BitcoinStats {
    
    init?(record: CKRecord) {
        
        if record.recordType != BitcoinStats.recordType { return nil }
        
        guard let blockHeight = record.object(forKey: "blockHeight") as? Int64 else { return nil }
        guard let blockSize = record.object(forKey: "blockSize") as? Int64 else { return nil }
        guard let difficulty = record.object(forKey: "difficulty") as? Int64 else { return nil }
        guard let hashRate = record.object(forKey: "hashRate") as? Double else { return nil }
        
        self.id = record.recordID.recordName
        
        self.blockHeight = blockHeight
        self.blockSize = blockSize
        self.difficulty = difficulty
        self.hashRate = hashRate
        
        self.recordId = record.recordID.recordName
        self.createdAt = record.creationDate ?? Date.now
        self.updatedAt = record.modificationDate ?? Date.now
    }
    
    func getCKRecord() -> CKRecord {
        
        let record = CKRecord(recordType: BitcoinStats.recordType, recordID: CKRecord.ID.init(recordName: recordId))
        record.setValue(blockHeight, forKey: "blockHeight")
        record.setValue(blockSize, forKey: "blockSize")
        record.setValue(difficulty, forKey: "difficulty")
        record.setValue(hashRate, forKey: "hashRate")

        return record
    }

}
