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
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text(entry.bitcoinPrice.formattedPrice())
                    .font(Font.custom("Digital-7Mono", size: 64))
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                Text("BTC-\(entry.bitcoinPrice.id.uppercased())")
                    .font(Font.custom("Digital-7Mono", size: 12))
                    .tracking(1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
            
            HStack {
                
                VStack(spacing: 4) {
                    Text(entry.bitcoinPrice.formattedMarketCapAbv(currencyCode: entry.bitcoinPrice.id))
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("MARKET CAP")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(entry.bitcoinPrice.formattedVolumeAbv(currencyCode: entry.bitcoinPrice.id))
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("TOTAL VOLUME")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    HStack {
                        Text(entry.bitcoinPrice.formattedPricePercentChange24())
                            .font(Font.custom("Digital-7Mono", size: 22))
                            .tracking(1)
                            .foregroundColor(.black)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                        Image(systemName: entry.bitcoinPrice.isUp ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                            .offset(x: 0, y: -1)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    }
                    Text("PRICE CHANGE")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 16)
            
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background {
            ZStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color("LCD"))
                    Rectangle()
                        .frame(height: 16)
                        .offset(x: 0, y: -16)
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 6)
                }
            }
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
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text("\(entry.bitcoinStats.blockHeight)")
                    .font(Font.custom("Digital-7Mono", size: 64))
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                Text("BLOCK HEIGHT")
                    .font(Font.custom("Digital-7Mono", size: 12))
                    .tracking(1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
            
            HStack {
                
                VStack(spacing: 4) {
                    Text(entry.bitcoinStats.formattedBlockSize())
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("BLOCK SIZE")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                
                VStack(spacing: 4) {
                    Text(entry.bitcoinStats.formattedHashRate())
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("TH/s")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(entry.bitcoinStats.formattedDifficulty())
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("DIFFICULTY")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 16)
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background {
            ZStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color("LCD"))
                    Rectangle()
                        .frame(height: 16)
                        .offset(x: 0, y: -16)
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 6)
                }
            }
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
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text(entry.lightningStats.formattedCapcity())
                    .font(Font.custom("Digital-7Mono", size: 56))
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                Text("NETWORK CAPACITY")
                    .font(Font.custom("Digital-7Mono", size: 12))
                    .tracking(1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
            
            HStack {
                
                VStack(spacing: 4) {
                    Text("\(entry.lightningStats.numberOfChannels)")
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("CHANNELS")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                
                VStack(spacing: 4) {
                    Text("\(entry.lightningStats.numberOfNodes)")
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("NODES")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(entry.lightningStats.numberOfNewNodes)")
                        .font(Font.custom("Digital-7Mono", size: 22))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                    Text("NEW NODES")
                        .font(Font.custom("Digital-7Mono", size: 12))
                        .tracking(1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 16)
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background {
            ZStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(Color("LCD"))
                    Rectangle()
                        .frame(height: 16)
                        .offset(x: 0, y: -16)
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 6)
                }
            }
            
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
