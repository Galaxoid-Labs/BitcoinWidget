//
//  FourValuePanelView.swift
//  FourValuePanelView
//
//  Created by Jacob Davis on 8/23/21.
//

import SwiftUI

struct FourValuePanelView: View {
    
    let mainView: LargeValueView
    let leftView: SmallValueView
    let middleView: SmallValueView
    let rightView: SmallValueView
    
    var body: some View {
        
        LazyVStack(spacing: 8) {
            
            mainView
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
            
            HStack {
                
                LazyVStack {
                    leftView
                }
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                
                LazyVStack {
                    middleView
                }
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                
                LazyVStack {
                    rightView
                }
                
            }
            .multilineTextAlignment(.center)
            .padding(.top, 4)
            .padding(.horizontal, 16)
            
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)

    }

}

struct FourValuePanelLargeView: View {
    
    let mainView: LargeValueView
    let leftView: MediumValueView
    let middleView: SmallValueView
    let rightView: MediumValueView
    
    var body: some View {
        
        LazyVStack(spacing: 8) {
            
            HStack(spacing: 8) {
                
                LazyVStack {
                    leftView
                }
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 1, y: 2)
                
                LazyVStack(spacing: 8) {
                    
                    mainView
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray, radius: 1, x: 0, y: 2)
                    
                    middleView
                    
                }
                
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray, radius: 1, x: 1, y: 2)
                
                LazyVStack {
                    rightView
                }
                
            }
            
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)

    }

}

struct FourValuePanelView_Previews: PreviewProvider {
    static var previews: some View {

        FourValuePanelView(mainView: LargeValueView(value: "$45,000", label: "BTC-USD"),
                           leftView: SmallValueView(value: "928.4B", label: "MARKET CAP"),
                           middleView: SmallValueView(value: "928.4B", label: "MARKET CAP"),
                           rightView: SmallValueView(value: "928.4B", label: "MARKET CAP")
        )
        .background {
            LCDBackgroundView(clipPadding: 8)
        }
        .previewLayout(.sizeThatFits)
    }
}

struct FourValuePanelLargeView_Previews: PreviewProvider {
    static var previews: some View {

        FourValuePanelLargeView(mainView: LargeValueView(value: "$45,000", label: "BTC-USD"),
                           leftView: MediumValueView(value: "928.4B", label: "MARKET CAP"),
                           middleView: SmallValueView(value: "928.4B", label: "MARKET CAP"),
                           rightView: MediumValueView(value: "928.4B", label: "MARKET CAP")
        )
        .background {
            LCDBackgroundView(clipPadding: 8)
        }
        .previewLayout(.sizeThatFits)
    }
}
