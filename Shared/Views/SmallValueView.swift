//
//  SmallValueView.swift
//  SmallValueView
//
//  Created by Jacob Davis on 8/23/21.
//

import SwiftUI

struct SmallValueView: View {
    
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Font.custom("Digital-7Mono", size: (UIDevice.isIPad || UIDevice.isTVOS) ? 48 : 22))
                .tracking(1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
            Text(label.uppercased())
                .font(Font.custom("Digital-7Mono", size: (UIDevice.isIPad || UIDevice.isTVOS) ? 24 : 12))
                .tracking(1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 3)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
    
}

struct SmallValueView_Previews: PreviewProvider {
    static var previews: some View {
        SmallValueView(value: "958.2B", label: "MARKET CAP")
    }
}
