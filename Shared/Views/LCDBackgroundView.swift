//
//  LCDBackgroundView.swift
//  LCDBackgroundView
//
//  Created by Jacob Davis on 8/20/21.
//

import SwiftUI

struct LCDBackgroundView: View {
    
    let clipPadding: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, style: .init(lineWidth: clipPadding > 0 ? 2 : 0))
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color("LCD"))
                Rectangle()
                    .frame(height: 16)
                    .offset(x: 0, y: -18)
                    .shadow(color: Color.gray, radius: 2, x: 0, y: 6)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
            .padding(clipPadding)
        }
    }
}

struct LCDBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        LCDBackgroundView(clipPadding: 0)
            .frame(height: 250)
    }
}
