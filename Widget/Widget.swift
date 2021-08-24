//
//  Widget.swift
//  Widget
//
//  Created by Jacob Davis on 8/20/21.
//

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
   var body: some Widget {
       MediumMarketWidget()
       MediumBitcoinNetworkWidget()
       MediumLightningNetworkWidget()
   }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        
        MediumMarketWidgetEntryView(entry: MarketWidgetDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date()))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        MediumBitcoinNetworkWidgetEntryView(entry: BitcoinNetworkWidgetDataEntry(bitcoinStats: BitcoinStats.placeHolder(), date: Date()))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        MediumLightningNetworkWidgetEntryView(entry: LightningNetworkWidgetDataEntry(lightningStats: LightningStats.placeHolder(), date: Date()))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemMedium))

    }
}

// MARK: - Market Widgets

struct MarketWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> MarketWidgetDataEntry {
        MarketWidgetDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MarketWidgetDataEntry) -> ()) {
        
        Task {
            await AppState.shared.loadAll()
            if let bitcoinPrice = AppState.shared.bitcoinPrice {
                completion(MarketWidgetDataEntry(bitcoinPrice: bitcoinPrice, date: Date()))
            } else {
                completion(MarketWidgetDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date()))
            }
        }

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Task {
            await CKManager.shared.fetchData()
            let timeline = Timeline(entries: [MarketWidgetDataEntry(bitcoinPrice: AppState.shared.bitcoinPrice ?? BitcoinPrice.placeHolder(), date: currentDate)], policy: .after(refreshDate))
            completion(timeline)
        }

    }
}

struct MarketWidgetDataEntry: TimelineEntry {
    let bitcoinPrice: BitcoinPrice
    let date: Date
}

// MARK: - Medium Market Widgets

struct MediumMarketWidgetEntryView : View {
    
    var entry: MarketWidgetProvider.Entry

    var body: some View {

        FourValuePanelView(mainView: LargeValueView(value: entry.bitcoinPrice.formattedPrice(),
                                                    label: "BTC-\(entry.bitcoinPrice.id.uppercased())"),
                           leftView: SmallValueView(value: entry.bitcoinPrice.formattedMarketCapAbv(currencyCode: entry.bitcoinPrice.id),
                                                    label: "MARKET CAP"),
                           middleView: SmallValueView(value: entry.bitcoinPrice.formattedVolumeAbv(currencyCode: entry.bitcoinPrice.id),
                                                      label: "TOTAL VOLUME"),
                           rightView: SmallValueView(value: entry.bitcoinPrice.formattedPricePercentChange24(),
                                                     label: "PRICE CHANGE"))
            .frame(maxHeight: .infinity)
            .background {
                LCDBackgroundView(clipPadding: 0)
            }
        
    }
}

struct MediumMarketWidget: SwiftUI.Widget {
    let kind: String = "MediumMarketWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MarketWidgetProvider()) { entry in
            MediumMarketWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Market")
        .description("This widget displays the current market conditions for Bitcoin.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Bitcoin Network Widgets

struct BitcoinNetworkWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> BitcoinNetworkWidgetDataEntry {
        BitcoinNetworkWidgetDataEntry(bitcoinStats: BitcoinStats.placeHolder(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (BitcoinNetworkWidgetDataEntry) -> ()) {
        
        Task {
            await AppState.shared.loadAll()
            if let bitcoinStats = AppState.shared.bitcoinStats {
                completion(BitcoinNetworkWidgetDataEntry(bitcoinStats: bitcoinStats, date: Date()))
            } else {
                completion(BitcoinNetworkWidgetDataEntry(bitcoinStats: BitcoinStats.placeHolder(), date: Date()))
            }
        }

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Task {
            await CKManager.shared.fetchData()
            let timeline = Timeline(entries: [BitcoinNetworkWidgetDataEntry(bitcoinStats: AppState.shared.bitcoinStats ?? BitcoinStats.placeHolder(), date: currentDate)], policy: .after(refreshDate))
            completion(timeline)
        }

    }
}

struct BitcoinNetworkWidgetDataEntry: TimelineEntry {
    let bitcoinStats: BitcoinStats
    let date: Date
}

// MARK: - Medium Bitcoin Network Widgets

struct MediumBitcoinNetworkWidgetEntryView : View {
    
    var entry: BitcoinNetworkWidgetProvider.Entry

    var body: some View {
        
        FourValuePanelView(mainView: LargeValueView(value: entry.bitcoinStats.formattedBlockHeight(),
                                                    label: "BLOCK HEIGHT"),
                           leftView: SmallValueView(value: entry.bitcoinStats.formattedBlockSize(),
                                                    label: "BLOCK SIZE"),
                           middleView: SmallValueView(value: entry.bitcoinStats.formattedHashRate(),
                                                      label: "TH/s"),
                           rightView: SmallValueView(value: entry.bitcoinStats.formattedDifficulty(),
                                                     label: "DIFFICULTY"))
                .frame(maxHeight: .infinity)
                .background {
                    LCDBackgroundView(clipPadding: 0)
                }

    }
}

struct MediumBitcoinNetworkWidget: SwiftUI.Widget {
    let kind: String = "MediumBitcoinNetworkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BitcoinNetworkWidgetProvider()) { entry in
            MediumBitcoinNetworkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bitcoin Network")
        .description("This widget displays the current network statistics for the Bitcoin Network.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Lightning Network Widgets

struct LightningNetworkWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> LightningNetworkWidgetDataEntry {
        LightningNetworkWidgetDataEntry(lightningStats: LightningStats.placeHolder(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (LightningNetworkWidgetDataEntry) -> ()) {
        
        Task {
            await AppState.shared.loadAll()
            if let lightningStats = AppState.shared.lightningStats {
                completion(LightningNetworkWidgetDataEntry(lightningStats: lightningStats, date: Date()))
            } else {
                completion(LightningNetworkWidgetDataEntry(lightningStats: LightningStats.placeHolder(), date: Date()))
            }
        }

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Task {
            await CKManager.shared.fetchData()
            let timeline = Timeline(entries: [LightningNetworkWidgetDataEntry(lightningStats: AppState.shared.lightningStats ?? LightningStats.placeHolder(), date: currentDate)], policy: .after(refreshDate))
            completion(timeline)
        }

    }
}

struct LightningNetworkWidgetDataEntry: TimelineEntry {
    let lightningStats: LightningStats
    let date: Date
}

// MARK: - Lightning Bitcoin Network Widgets

struct MediumLightningNetworkWidgetEntryView : View {
    
    var entry: LightningNetworkWidgetProvider.Entry

    var body: some View {
        
        FourValuePanelView(mainView: LargeValueView(value: entry.lightningStats.formattedCapcity(),
                                                    label: "CAPACITY IN BTC"),
                           leftView: SmallValueView(value: "\(entry.lightningStats.numberOfChannels)",
                                                    label: "CHANNELS"),
                           middleView: SmallValueView(value: "\(entry.lightningStats.numberOfNodes)",
                                                      label: "NODES"),
                           rightView: SmallValueView(value: "\(entry.lightningStats.numberOfNewNodes)",
                                                     label: "NEW NODES"))
            .frame(maxHeight: .infinity)
            .background {
                LCDBackgroundView(clipPadding: 0)
            }
        
    }
}

struct MediumLightningNetworkWidget: SwiftUI.Widget {
    let kind: String = "MediumLightningNetworkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LightningNetworkWidgetProvider()) { entry in
            MediumLightningNetworkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lightning Network")
        .description("This widget displays the current network statistics for the Lightning Network.")
        .supportedFamilies([.systemMedium])
    }
}
