//
//  Widget.swift
//  Widget
//
//  Created by Jacob Davis on 8/20/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> MarketDataEntry {
        MarketDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MarketDataEntry) -> ()) {
        
        Task {
            await AppState.shared.loadAll()
            if let bitcoinPrice = AppState.shared.bitcoinPrice {
                completion(MarketDataEntry(bitcoinPrice: bitcoinPrice, date: Date()))
            } else {
                completion(MarketDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date()))
            }
        }

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Task {
            await CKManager.shared.fetchData()
            let timeline = Timeline(entries: [MarketDataEntry(bitcoinPrice: AppState.shared.bitcoinPrice ?? BitcoinPrice.placeHolder(), date: currentDate)], policy: .after(refreshDate))
            completion(timeline)
        }

    }
}

struct MarketDataEntry: TimelineEntry {
    let bitcoinPrice: BitcoinPrice
    let date: Date
}

struct WidgetEntryView : View {
    var entry: Provider.Entry

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
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
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
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 32)
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
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

@main
struct Widgets: WidgetBundle {
   var body: some Widget {
       MediumMarketWidget()
   }
}

struct MediumMarketWidget: SwiftUI.Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Market")
        .description("This widget displays the current market conditions for Bitcoin.")
        .supportedFamilies([.systemMedium])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: MarketDataEntry(bitcoinPrice: BitcoinPrice.placeHolder(), date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
