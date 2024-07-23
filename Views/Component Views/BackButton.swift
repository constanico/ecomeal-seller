//
//  BackButton.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 25/11/23.
//

import SwiftUI

struct BackButton: View {
    var onButtonTap: () -> Void
    var body: some View {
        Button(action: {
            onButtonTap()
        }) {
            HStack{
                Image(systemName: "chevron.left")
                    .foregroundColor(.green)
                
            }
            .frame(width: 40, height: 40)
            .background(.green.opacity(0.2))
            .cornerRadius(50)
        }
    }
}

#Preview {
    BackButton(onButtonTap: {})
}
