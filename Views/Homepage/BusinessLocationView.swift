//
//  BusinessLocationView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import SwiftUI

struct BusinessLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    var body: some View {
        NavigationView{
            VStack{
                StaticMapView(latitude: $latitude, longitude: $longitude, lockToPin: true)
                
            }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                
                }
                )
                
        }
    }
}
#Preview {
    BusinessLocationView(latitude: .constant(1), longitude: .constant(0))
}
