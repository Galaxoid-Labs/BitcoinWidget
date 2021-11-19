//
//  SettingsView.swift
//  BitcoinWidget
//
//  Created by Jacob Davis on 9/20/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Form {
                    
                    Section("API Sources") {
                        HStack(spacing: 16) {
                            Image("blockchain.com-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIDevice.isTVOS ? 40 : 20, height: UIDevice.isTVOS ? 40 : 20)
                            Text("[https://blockchain.com](https://www.blockchain.com/api)")
                        }
                        
                        HStack(spacing: 16) {
                            Image("coingecko-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIDevice.isTVOS ? 40 : 20, height: UIDevice.isTVOS ? 40 : 20)
                            Text("[https://coingecko.com](https://www.coingecko.com/en/api)")
                        }
                    }
                    
                    Section("Support & Suggestions") {
                        HStack(spacing: 16) {
                            Image(systemName: "envelope.fill")
                            Text("[basio@galaxoidlabs.com](mailto:basio@galaxoidlabs.com)")
                        }
                        HStack(spacing: 16) {
                            Image(systemName: "network")
                            Text("[https://galaxoidlabs.com/basio](https://galaxoidlabs.com/basio)")
                        }
                    }

                }
                
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
    
    }
    
    func donate() {
        guard let url = URL(string: "bitcoin:bc1qgdjnwm3k3fhhndqknw8wqnykvsx4ag5nnnn3rj") else {
            return
        }
        openURL(url)
    }
    
    func website() {
        guard let url = URL(string: "bitcoin:bc1qgdjnwm3k3fhhndqknw8wqnykvsx4ag5nnnn3rj") else {
            return
        }
        openURL(url)
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
