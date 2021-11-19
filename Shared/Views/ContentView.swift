//
//  ContentView.swift
//  Shared
//
//  Created by Jacob Davis on 8/16/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var settingsViewPresented = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { proxy in
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 8) {
                        
                        MainHeaderView(settingsViewPresented: $settingsViewPresented)
                        #if os(iOS)
                            .padding(.bottom, 16)
                        #endif // CHECK
                        
                        #if os(iOS)
                        Spacer()
                        #endif
                        
                        HeaderView(color: .blue, title: "CURRENT MARKET",
                                   systemImageName: "chart.xyaxis.line",
                                   systemImageColor: appState.bitcoinPrice?.isUp ?? true ? .green : .red,
                                   verticallyFlipImage: !(appState.bitcoinPrice?.isUp ?? true))
                        
                        #if os(tvOS)
                        FourValuePanelLargeView(mainView: LargeValueView(value: appState.bitcoinPrice?.formattedPrice() ?? "$45,000",
                                                                    label: "BTC-\(appState.currencyCode.uppercased())"),
                                           leftView: MediumValueView(value: appState.bitcoinPrice?.formattedMarketCapAbv(currencyCode: appState.currencyCode) ?? "$857.2B",
                                                                    label: "MARKET CAP"),
                                           middleView: SmallValueView(value: appState.bitcoinPrice?.formattedVolumeAbv(currencyCode: appState.currencyCode) ?? "$36.9B",
                                                                      label: "TOTAL VOLUME"),
                                           rightView: MediumValueView(value: appState.bitcoinPrice?.formattedPricePercentChange24() ?? "0.00%",
                                                                     label: "PRICE CHANGE"))
                                .background {
                                    LCDBackgroundView(clipPadding: 8)
                                }
                                .padding(.bottom, 16)
                        #else
                        FourValuePanelView(mainView: LargeValueView(value: appState.bitcoinPrice?.formattedPrice() ?? "$45,000",
                                                                    label: "BTC-\(appState.currencyCode.uppercased())"),
                                           leftView: SmallValueView(value: appState.bitcoinPrice?.formattedMarketCapAbv(currencyCode: appState.currencyCode) ?? "$857.2B",
                                                                    label: "MARKET CAP"),
                                           middleView: SmallValueView(value: appState.bitcoinPrice?.formattedVolumeAbv(currencyCode: appState.currencyCode) ?? "$36.9B",
                                                                      label: "TOTAL VOLUME"),
                                           rightView: SmallValueView(value: appState.bitcoinPrice?.formattedPricePercentChange24() ?? "0.00%",
                                                                     label: "PRICE CHANGE"))
                                .background {
                                    LCDBackgroundView(clipPadding: 8)
                                }
                                .padding(.bottom, 16)
                        #endif
                        
                        HeaderView(color: .blue, title: "BITCOIN NETWORK",
                                   systemImageName: "network",
                                   systemImageColor: .gray,
                                   verticallyFlipImage: false)
                        
                        #if os(tvOS)
                        FourValuePanelLargeView(mainView: LargeValueView(value: appState.bitcoinStats?.formattedBlockHeight() ?? "650,321",
                                                                    label: "BLOCK HEIGHT"),
                                           leftView: MediumValueView(value: appState.bitcoinStats?.formattedBlockSize() ?? "0.72 MB",
                                                                    label: "BLOCK SIZE"),
                                           middleView: SmallValueView(value: appState.bitcoinStats?.formattedHashRate() ?? "130.0 M",
                                                                      label: "TH/s"),
                                           rightView: MediumValueView(value: appState.bitcoinStats?.formattedDifficulty() ?? "130.0 M",
                                                                     label: "DIFFICULTY"))
                            .background {
                                LCDBackgroundView(clipPadding: 8)
                            }
                            .padding(.bottom, 16)
                        #else
                        FourValuePanelView(mainView: LargeValueView(value: appState.bitcoinStats?.formattedBlockHeight() ?? "650,321",
                                                                    label: "BLOCK HEIGHT"),
                                           leftView: SmallValueView(value: appState.bitcoinStats?.formattedBlockSize() ?? "0.72 MB",
                                                                    label: "BLOCK SIZE"),
                                           middleView: SmallValueView(value: appState.bitcoinStats?.formattedHashRate() ?? "130.0 M",
                                                                      label: "TH/s"),
                                           rightView: SmallValueView(value: appState.bitcoinStats?.formattedDifficulty() ?? "130.0 M",
                                                                     label: "DIFFICULTY"))
                            .background {
                                LCDBackgroundView(clipPadding: 8)
                            }
                            .padding(.bottom, 16)
                        #endif
                        
                        HeaderView(color: .blue, title: "LIGHTNING NETWORK",
                                   systemImageName: "bolt.fill",
                                   systemImageColor: .yellow,
                                   verticallyFlipImage: false)
                        
                        #if os(tvOS)
                        FourValuePanelLargeView(mainView: LargeValueView(value: appState.lightningStats?.formattedCapcity() ?? "2,000",
                                                                    label: "CAPACITY IN BTC"),
                                           leftView: MediumValueView(value: "\(appState.lightningStats?.numberOfChannels ?? 0)",
                                                                    label: "CHANNELS"),
                                           middleView: SmallValueView(value: "\(appState.lightningStats?.numberOfNodes ?? 0)",
                                                                      label: "NODES"),
                                           rightView: MediumValueView(value: "\(appState.lightningStats?.numberOfNewNodes ?? 0)",
                                                                     label: "NEW NODES"))
                            .background {
                                LCDBackgroundView(clipPadding: 8)
                            }
                            .padding(.bottom, 16)
                        #else
                        FourValuePanelView(mainView: LargeValueView(value: appState.lightningStats?.formattedCapcity() ?? "2,000",
                                                                    label: "CAPACITY IN BTC"),
                                           leftView: SmallValueView(value: "\(appState.lightningStats?.numberOfChannels ?? 0)",
                                                                    label: "CHANNELS"),
                                           middleView: SmallValueView(value: "\(appState.lightningStats?.numberOfNodes ?? 0)",
                                                                      label: "NODES"),
                                           rightView: SmallValueView(value: "\(appState.lightningStats?.numberOfNewNodes ?? 0)",
                                                                     label: "NEW NODES"))
                            .background {
                                LCDBackgroundView(clipPadding: 8)
                            }
                            .padding(.bottom, 16)
                        #endif
                        
                        Spacer()
                        
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    .frame(minHeight: proxy.size.height)
                    
                }
                
                
            }

        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $settingsViewPresented) {
            SettingsView()
        }
        
    }
}

struct MainHeaderView: View {
    
    @Binding var settingsViewPresented: Bool
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        VStack(spacing: 4) {
            
            HStack(alignment: .lastTextBaseline) {
                
                Text("BASIO")
                    .foregroundColor(.white)
                    .font(.system(size: (UIDevice.isIPad || UIDevice.isTVOS) ? 42 : 32))
                    .fontWeight(.black)
                Spacer()
                
                Button(action: { settingsViewPresented.toggle() }) {
                    HStack(spacing: 0) {
                        
                        Text("BITCOIN SPY") { string in
                            string.foregroundColor = UIDevice.isTVOS ? .white : .gray
                            if let range = string.range(of: "BITCOIN") {
                                string[range].foregroundColor = UIDevice.isTVOS ? .white : .gray
                            }
                        }
                        .font(.system(size: (UIDevice.isIPad || UIDevice.isTVOS) ? 24 : 17))
                        .fontWeight(.heavy)
                        .padding(.trailing, 4)

                        ForEach(0..<3) { _ in
                            Image(systemName: "arrowtriangle.right.fill")
                                .foregroundColor(.orange)
                        }
                        .font(.system(size: (UIDevice.isIPad || UIDevice.isTVOS) ? 22 : 15))
                        
                    }
                    #if os(tvOS)
                    .padding(8)
                    #endif
                }
                
                #if os(tvOS)
                .buttonStyle(CardButtonStyle())
                .padding(.horizontal)
                #else
                .buttonStyle(PlainButtonStyle())
                #endif

                
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
                .frame(height: (UIDevice.isIPad || UIDevice.isTVOS) ? 3 : 3)
            
            HStack {
                Image(systemName: systemImageName)
                    .foregroundColor(systemImageColor)
                    .scaleEffect(CGSize(width: 1.0, height: verticallyFlipImage ? -1.0 : 1.0))
                    .font(.system(size: (UIDevice.isIPad || UIDevice.isTVOS) ? 24 : 18))
                
                Spacer()
                Text(title)
                    .foregroundColor(.brown)
                    .font(.system(size: (UIDevice.isIPad || UIDevice.isTVOS) ? 19 : 12))
                    .fontWeight(.bold)
            }
            
        }
        
    }
    
}


// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState.shared)
    }
}
