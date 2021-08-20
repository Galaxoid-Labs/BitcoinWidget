//
//  AppState.swift
//  AppState
//
//  Created by Jacob Davis on 8/17/21.
//

import Foundation
import SwiftUI
import CloudKit
import EasyStash

class AppState: ObservableObject {
    
    // Data
    @Published var bitcoinStats: BitcoinStats? = nil
    @Published var lightningStats: LightningStats? = nil
    @Published var bitcoinPrice: BitcoinPrice? = nil
    
    @AppStorage("currencyCode", store: UserDefaults(suiteName: "group.com.galaxoidlabs.BitcoinWidget")) var currencyCode: String = "usd"
    @Published var languageCode = "en"
    
    private var storage: Storage?
    
    static let shared = AppState()
    
    private init() {
        
        var options = Options()
        options.folder = "storage"
        
        do {
            storage = try Storage(options: options)
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    @MainActor
    func loadAll() {
        
        guard let storage = self.storage else {
            fatalError("Unable to unwrap storage")
        }

        if let bitcoinStats = try? storage.load(forKey: "bitcoinStats", as: BitcoinStats.self) {
            self.bitcoinStats = bitcoinStats
        }
        
        if let lightningStats = try? storage.load(forKey: "lightningStats", as: LightningStats.self) {
            self.lightningStats = lightningStats
        }
        
        if let bitcoinPrice = try? storage.load(forKey: "bitcoinPrice", as: BitcoinPrice.self) {
            self.bitcoinPrice = bitcoinPrice
        }
        
    }
    
    @MainActor
    func saveAll() {
        
        guard let storage = self.storage else {
            fatalError("Unable to unwrap storage")
        }

        do {
            try storage.save(object: self.bitcoinStats, forKey: "bitcoinStats")
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            try storage.save(object: self.lightningStats, forKey: "lightningStats")
        } catch {
            print(error.localizedDescription)
        }
        
        do {
            try storage.save(object: self.bitcoinPrice, forKey: "bitcoinPrice")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
