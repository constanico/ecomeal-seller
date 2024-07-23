//
//  OvalTextFieldStyle.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 30)
            .foregroundColor(.gray)
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.3), radius: 5, y: 5)
    }
}
