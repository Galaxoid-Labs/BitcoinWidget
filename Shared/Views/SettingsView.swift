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
                        HStack {
                            Image("blockchain.com-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text("[blockchain.com](https://www.blockchain.com/api)")
                        }
                        
                        HStack {
                            Image("coingecko-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text("[coingecko.com](https://www.coingecko.com/en/api)")
                        }
                    }
                    
                    Section("Support & Suggestions") {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("[basio@galaxoidlabs.com](mailto:basio@galaxoidlabs.com)")
                        }
                        HStack {
                            Image(systemName: "network")
                            Text("[galaxoidlabs.com/basio](https://galaxoidlabs.com/basio)")
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
