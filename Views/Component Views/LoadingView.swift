//
//  LoadingView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/11/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 120, height: 120)
                .cornerRadius(15)
                .opacity(0.3)
            VStack{
                ProgressView()
                    .tint(.white)
                    .frame(width: 50, height: 50)
                Text("Loading")
                    .foregroundColor(.white)
                    .bold()
            }
            
        }
    }
}

#Preview {
    LoadingView()
}
