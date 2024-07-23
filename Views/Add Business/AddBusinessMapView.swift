//
//  AddBusinessMapView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import FirebaseAuth

struct AddBusinessMapView: View {
    @StateObject var businessViewModel = BusinessViewModel()
    @StateObject var itemViewModel = ItemViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    var body: some View {
        NavigationView{
            VStack{
                EditableMarkerMapView(latitude: $latitude, longitude: $longitude)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Choose Location")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 300, height: 50)
                        .background(.green)
                        .cornerRadius(12)
                }
                .padding()
               
            }
            .navigationTitle("Map View")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                
                )
        }
    }
}

#Preview {
    AddBusinessMapView(latitude: .constant(0), longitude: .constant(0))
}
