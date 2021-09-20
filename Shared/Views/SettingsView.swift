//
//  SettingsView.swift
//  BitcoinWidget
//
//  Created by Jacob Davis on 9/20/21.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    
    var body: some View {
    
        ZStack {
            
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Form {
                    
                    Section("API Sources") {
                        HStack {
                            Image("blockchain.com-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text("Blockchain.com")
                        }
                        .frame(height: 44)
                        
                        HStack {
                            Image("coingecko-logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                            Text("Coingecko.com")
                        }
                        .frame(height: 44)
                    }
                    
                    Section("Support & Suggestions") {
                        Text("[basio@galaxoidlabs.com](mailto:basio@galaxoidlabs.com)")
                    }

                    LazyVStack(alignment: .center) {
                        Image("donate")
                            .resizable()
                            .frame(width: 101, height: 128)
                            .padding()
                            .background()
                            .cornerRadius(8)
                    }
                    .padding()
                    .onTapGesture {
                        donate()
                    }
                    
                    Text("In accordance with the [AppStore Guidelines, section 3.2.1 (vii)](https://developer.apple.com/app-store/review/guidelines/#acceptable) it should be noted that 100% of any donation made will be received by Galaxoid Labs to help make our products better and that the sender will not receive anything in return except for gratitude and thanks!")
                        .font(.caption.italic())
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical)
                    
                    
                }
                .background(Color.red)
                
            }
            .background(Color.red)
            
            
            
        }
        .preferredColorScheme(.dark)
        
    }
    
    func donate() {
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
