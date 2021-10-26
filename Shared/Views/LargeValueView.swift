//
//  LargeValueView.swift
//  LargeValueView
//
//  Created by Jacob Davis on 8/23/21.
//

import SwiftUI

struct LargeValueView: View {
    
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(Font.custom("Digital-7Mono", size: (UIDevice.isIPad || UIDevice.isTVOS) ? 96 : 60))
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
            Text(LocalizedStringKey(label))
                .font(Font.custom("Digital-7Mono", size: (UIDevice.isIPad || UIDevice.isTVOS) ? 24 : 12))
                .tracking(1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
    
}

struct LargeValueView_Previews: PreviewProvider {
    static var previews: some View {
        LargeValueView(value: "$45,000", label: "BTC-USD")
    }
}
