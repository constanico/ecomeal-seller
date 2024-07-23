//
//  MessageBubble.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 26/11/23.
//

import SwiftUI

struct MessageBubble: View {
    let message: String
    let textColor: Color
    let bubbleColor: Color
    var body: some View {
        VStack{
            Text(message)
                .foregroundColor(textColor)
                .padding(15)
                .background {
                    Rectangle()
                        .fill(bubbleColor)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
                }
        }

    }
}

#Preview {
    MessageBubble(message: "ECOMEAL is amazing.", textColor: .white, bubbleColor: .green)
}
