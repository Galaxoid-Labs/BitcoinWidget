//
//  CKManager.swift
//  CKManager
//
//  Created by Jacob Davis on 8/17/21.
//

import Foundation
import CloudKit
import UIKit
import SwiftUI

class CKManager {
    
    fileprivate let publicDB = CKContainer(identifier: "iCloud.com.galaxoidlabs.BitcoinWidget").publicCloudDatabase
    fileprivate var bitcoinStatsSub: CKSubscription.ID?
    fileprivate var lightningStatsSub: CKSubscription.ID?
    fileprivate var bitcoinPricesSub: CKSubscription.ID?

    static let shared = CKManager()
    
    private init() {
        
    }
    
    func initBitcoinDataSubs() async {
        
        do {
            
            let subs = try await publicDB.allSubscriptions()
            let querySubs = subs.compactMap({ $0 as? CKQuerySubscription })
            
            bitcoinStatsSub = querySubs.first(where: { $0.recordType == BitcoinStats.recordType })?.subscriptionID
            lightningStatsSub = querySubs.first(where: { $0.recordType == LightningStats.recordType })?.subscriptionID
            bitcoinPricesSub = querySubs.first(where: { $0.recordType == BitcoinPrice.recordType })?.subscriptionID

            if bitcoinStatsSub == nil {
                
                let subscription = CKQuerySubscription(recordType: BitcoinStats.recordType,
                                      predicate: NSPredicate(value: true))

                let notificationInfo = CKSubscription.NotificationInfo()
                notificationInfo.shouldSendContentAvailable = true

                subscription.notificationInfo = notificationInfo
                
                do {
                    try await publicDB.save(subscription)
                    bitcoinStatsSub = subscription.subscriptionID
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
            if lightningStatsSub == nil {
                
                let subscription = CKQuerySubscription(recordType: LightningStats.recordType,
                                      predicate: NSPredicate(value: true))

                let notificationInfo = CKSubscription.NotificationInfo()
                notificationInfo.shouldSendContentAvailable = true

                subscription.notificationInfo = notificationInfo
                
                do {
                    try await publicDB.save(subscription)
                    lightningStatsSub = subscription.subscriptionID
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
            if bitcoinPricesSub == nil {
                
                let subscription = CKQuerySubscription(recordType: BitcoinPrice.recordType,
                                      predicate: NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: AppState.shared.currencyCode)))

                let notificationInfo = CKSubscription.NotificationInfo()
                notificationInfo.shouldSendContentAvailable = true

                subscription.notificationInfo = notificationInfo
                
                do {
                    try await publicDB.save(subscription)
                    bitcoinPricesSub = subscription.subscriptionID
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateBitcoinPriceSub() async {
        
        if let bitcoinPricesSub = bitcoinPricesSub {
            let _ = try? await publicDB.deleteSubscription(withID: bitcoinPricesSub)
            self.bitcoinPricesSub = nil
        }
        
        let subscription = CKQuerySubscription(recordType: BitcoinPrice.recordType,
                              predicate: NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: AppState.shared.currencyCode)))

        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true

        subscription.notificationInfo = notificationInfo

        do {
            try await publicDB.save(subscription)
            bitcoinPricesSub = subscription.subscriptionID
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @MainActor
    func fetchData() async {
        
        if let record = try? await publicDB.record(for: CKRecord.ID(recordName: BitcoinStats.recordType)) {
            await updateLocalState(for: record, reason: .recordUpdated)
        }
        
        if let record = try? await publicDB.record(for: CKRecord.ID(recordName: LightningStats.recordType)) {
            await updateLocalState(for: record, reason: .recordUpdated)
        }
        
        let query = CKQuery(recordType: BitcoinPrice.recordType, predicate: NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: AppState.shared.currencyCode)))
        if let records = try? await publicDB.records(matching: query, resultsLimit: 1),
            let record = try? records.matchResults.first?.1.get() {
            await updateLocalState(for: record, reason: .recordUpdated)
        }
    }
    
    @MainActor
    fileprivate func fetchPublicRecord(for reckordId: CKRecord.ID) async -> CKRecord? {
        return try? await publicDB.record(for: reckordId)
    }
    
    @MainActor
    fileprivate func removeFromLocalState(for recordType: String, and recordId: CKRecord.ID) async {
        if recordType == BitcoinStats.recordType {
            AppState.shared.bitcoinStats = nil
        } else if recordType == LightningStats.recordType {
            AppState.shared.lightningStats = nil
        } else if recordType == BitcoinPrice.recordType {
            AppState.shared.bitcoinPrice = nil
        }
    }
    
    @MainActor
    fileprivate func updateLocalState(for record: CKRecord, reason: CKQueryNotification.Reason) async {

        if record.recordType == BitcoinStats.recordType {
            
            if let bitcoinStats = BitcoinStats(record: record) {
        
                AppState.shared.bitcoinStats = bitcoinStats
                
            }
            
        } else if record.recordType == LightningStats.recordType {
            
            if let lightningStats = LightningStats(record: record) {
        
                AppState.shared.lightningStats = lightningStats
                
            }

        } else if record.recordType == BitcoinPrice.recordType {
            
            if let bitcoinPrice = BitcoinPrice(record: record) {
                
                if bitcoinPrice.id == AppState.shared.currencyCode {
                    AppState.shared.bitcoinPrice = bitcoinPrice
                }

            }
            
        }
        
    }
    
    // MARK: - AppDelegate Handlers
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {

        if let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) {

            print("CloudKit database changed: \(notification)")

            if let query = notification as? CKQueryNotification, let recordID = query.recordID {

                if query.databaseScope == CKDatabase.Scope.public {
                    
                    if query.queryNotificationReason == CKQueryNotification.Reason.recordDeleted {

                        if notification.subscriptionID == bitcoinStatsSub {
                            await removeFromLocalState(for: BitcoinStats.recordType, and: recordID)
                        } else if notification.subscriptionID == lightningStatsSub {
                            await removeFromLocalState(for: LightningStats.recordType, and: recordID)
                        } else if notification.subscriptionID == bitcoinPricesSub {
                            await removeFromLocalState(for: BitcoinStats.recordType, and: recordID)
                        }

                    } else {

                        if let record = await fetchPublicRecord(for: recordID) {
                            await updateLocalState(for: record, reason: query.queryNotificationReason)
                            return .newData
                        }

                    }

                }

            }

        }

        return .noData

    }
    
}
