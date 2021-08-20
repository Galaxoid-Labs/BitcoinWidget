//
//  LCDBackgroundView.swift
//  LCDBackgroundView
//
//  Created by Jacob Davis on 8/20/21.
//

import SwiftUI

struct LCDBackgroundView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, style: .init(lineWidth: 2))
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color("LCD"))
                Rectangle()
                    .frame(height: 16)
                    .offset(x: 0, y: -16)
                    .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
            .padding(6)
        }
    }
}

struct LCDBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        LCDBackgroundView()
    }
}
