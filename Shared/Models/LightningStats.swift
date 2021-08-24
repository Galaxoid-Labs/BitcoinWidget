//
//  LightningStats.swift
//  LightningStats
//
//  Created by Jacob Davis on 8/19/21.
//

import Foundation
import CloudKit

struct LightningStats: Codable, Hashable, Identifiable {
    
    let id: String
    
    let numberOfNodes: Int
    let numberOfNewNodes: Int
    let numberOfChannels: Int
    let numberOfNewChannels: Int
    let capacity: Double
    
    let updatedAt: Date
    let createdAt: Date
    
    let recordId: String
    static let recordType: String = "LightningStats"
    
    func formattedCapcity() -> String {
        return capacity.formatted(.number.precision(.fractionLength(0...2)))
    }
    
    static func placeHolder() -> LightningStats {
        return LightningStats(id: "LightningStats", numberOfNodes: 0, numberOfNewNodes: 0,
                              numberOfChannels: 0, numberOfNewChannels: 0, capacity: 2328.18,
                              updatedAt: .now, createdAt: .now, recordId: "LightningStats")
    }
    
}

extension LightningStats {
    
    init?(record: CKRecord) {
        
        if record.recordType != LightningStats.recordType { return nil }
        
        guard let numberOfNodes = record.object(forKey: "numberOfNodes") as? Int else { return nil }
        guard let numberOfNewNodes = record.object(forKey: "numberOfNewNodes") as? Int else { return nil }
        guard let numberOfChannels = record.object(forKey: "numberOfChannels") as? Int else { return nil }
        guard let numberOfNewChannels = record.object(forKey: "numberOfNewChannels") as? Int else { return nil }
        guard let capacity = record.object(forKey: "capacity") as? Double else { return nil }
        
        self.id = record.recordID.recordName
        
        self.numberOfNodes = numberOfNodes
        self.numberOfNewNodes = numberOfNewNodes
        self.numberOfChannels = numberOfChannels
        self.numberOfNewChannels = numberOfNewChannels
        self.capacity = capacity
        
        self.recordId = record.recordID.recordName
        self.createdAt = record.creationDate ?? Date.now
        self.updatedAt = record.modificationDate ?? Date.now
    }
    
    func getCKRecord() -> CKRecord {
        
        let record = CKRecord(recordType: LightningStats.recordType, recordID: CKRecord.ID.init(recordName: recordId))
        record.setValue(numberOfNodes, forKey: "numberOfNodes")
        record.setValue(numberOfNewNodes, forKey: "numberOfNewNodes")
        record.setValue(numberOfChannels, forKey: "numberOfChannels")
        record.setValue(numberOfNewChannels, forKey: "numberOfNewChannels")
        record.setValue(capacity, forKey: "capacity")
        
        return record
    }

}
