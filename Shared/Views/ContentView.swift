//
//  ContentView.swift
//  Shared
//
//  Created by Jacob Davis on 8/16/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                VStack(spacing: 8) {
                    
                    MainHeaderView()
                        .padding(.bottom, 16)
                    
                    HeaderView(color: .blue, title: "CURRENT MARKET",
                               systemImageName: "chart.xyaxis.line",
                               systemImageColor: appState.bitcoinPrice?.isUp ?? true ? .green : .red,
                               verticallyFlipImage: !(appState.bitcoinPrice?.isUp ?? true))
                    
                    MarketStatsView()
                        .padding(.bottom, 16)
                    
                    HeaderView(color: .blue, title: "BITCOIN NETWORK",
                               systemImageName: "network",
                               systemImageColor: .gray,
                               verticallyFlipImage: false)
                    
                    ChainStatsView()
                        .padding(.bottom, 16)
                    
                    HeaderView(color: .blue, title: "LIGHTNING NETWORK",
                               systemImageName: "bolt.fill",
                               systemImageColor: .yellow,
                               verticallyFlipImage: false)
                    
                    LightningStatsView()
                        .padding(.bottom, 16)
                    
                }
                .padding(.leading, 12)
                .padding(.trailing, 12)
                
            }
            
        }
        .preferredColorScheme(.dark)
        
    }
}

struct MarketStatsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text(appState.bitcoinPrice?.formattedPrice() ?? "$44,342")
                    .font(Font.custom("Digital-7Mono", size: 64))
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                Text("BTC-\(appState.currencyCode.uppercased())")
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
                    Text(appState.bitcoinPrice?.formattedMarketCapAbv(currencyCode: appState.currencyCode) ?? "$857.2B")
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
                    Text(appState.bitcoinPrice?.formattedVolumeAbv(currencyCode: appState.currencyCode) ?? "$36.9B")
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
                        Text(appState.bitcoinPrice?.formattedPricePercentChange24() ?? "0.00%")
                            .font(Font.custom("Digital-7Mono", size: 22))
                            .tracking(1)
                            .foregroundColor(.black)
                            .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                        Image(systemName: (appState.bitcoinPrice?.isUp ?? true) ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
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
            LCDBackgroundView()
        }
        
    }
}

struct MainHeaderView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        VStack(spacing: 4) {
            
            HStack(alignment: .lastTextBaseline) {
                
                Text("BASIO")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
                
                
                HStack(spacing: 0) {
                    
                    ForEach(0..<3) { _ in
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundColor(.orange)
                    }
                    .font(.subheadline)
                    
                    Text("BITCOIN SPY") { string in
                        string.foregroundColor = .gray
                        if let range = string.range(of: "BITCOIN") {
                            string[range].foregroundColor = .gray
                        }
                    }
                    .font(.body)
                    .fontWeight(.heavy)
                    .padding(.leading, 4)
                    
                }
                
            }
            
        }
        
    }
    
}

struct HeaderView: View {
    
    let color: Color
    let title: String
    let systemImageName: String
    let systemImageColor: Color
    let verticallyFlipImage: Bool
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            Rectangle()
                .fill(color)
                .frame(height: 3)
            
            HStack {
                Image(systemName: systemImageName)
                    .foregroundColor(systemImageColor)
                    .scaleEffect(CGSize(width: 1.0, height: verticallyFlipImage ? -1.0 : 1.0))
                
                Spacer()
                Text(title)
                    .foregroundColor(.brown)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
        }
        
    }
    
}

struct ChainStatsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text("\(appState.bitcoinStats?.blockHeight ?? 650321)")
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
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
            
            HStack {
                
                VStack(spacing: 4) {
                    Text(appState.bitcoinStats?.formattedBlockSize() ?? "0.72 MB")
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
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                
                VStack(spacing: 4) {
                    Text(appState.bitcoinStats?.formattedHashRate() ?? "130.0 M")
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
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(appState.bitcoinStats?.formattedDifficulty() ?? "130.0 M")
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
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 32)
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
        .background {
            LCDBackgroundView()
        }
        
    }
}

struct LightningStatsView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        LazyVStack(spacing: 8) {
            
            VStack {
                Text(appState.lightningStats?.formattedCapcity() ?? "2,000 BTC")
                    .font(Font.custom("Digital-7Mono", size: 48))
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
                Text("NETWORK CAPACITY")
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
                    Text("\(appState.lightningStats?.numberOfChannels ?? 0)")
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
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                
                VStack(spacing: 4) {
                    Text("\(appState.lightningStats?.numberOfNodes ?? 0)")
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
                
                Spacer()
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("\(appState.lightningStats?.numberOfNewNodes ?? 0)")
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
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 32)
        }
        .padding(.top, 18)
        .padding(.bottom, 14)
        .background {
            LCDBackgroundView()
        }
        
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState.shared)
    }
}
