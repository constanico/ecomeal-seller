//
//  BusinessView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI

struct BusinessView: View {
    @StateObject var businessViewModel = BusinessViewModel()
    @StateObject var orderViewModel = OrderViewModel()
    
    @State private var isAddBusinessViewShown = false
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                if businessViewModel.businesses.isEmpty{
                    VStack{
                        
                        Image(systemName: "building.2.crop.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.darkGreen)
                            .frame(width: 100, height: 100)
                            
                        Text("You have no businesses")
                            .foregroundColor(Color(ColorString.darkGreen.colorText))
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 30)
                        
                        Button(action: {
                            isAddBusinessViewShown = true
                        }) {
                            Text("Add a new business")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 300, height: 55)
                                .background(.green)
                                .cornerRadius(50)
                        }
                        .padding()
                        
                        
                    }
                }else{
                    ScrollView{
                        HStack{
                            Text("Your Businesses").font(.title)
                                .bold()
                                .padding()
                                .padding(.top, 10)
                            Spacer()
                        }
                        ForEach(businessViewModel.businesses, id: \.self) { item in
                            NavigationLink(destination: BusinessDetailView(business: item)) {
                                CustomRowView(imageUrl: item.imageUrl ?? "", title: item.businessName, subtitle: item.businessIsOpen ? "Business is open" : "Business is closed", description: item.businessAddress, starRating: item.businessRating)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 2.5)
                            
                        }.buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
                }
            }.navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("ECOMEAL Seller")
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(
                    Color(ColorString.lightGreen.colorText),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .edgesIgnoringSafeArea(.bottom)
            
                .navigationBarItems(trailing:
                                        Button(action: {
                    isAddBusinessViewShown = true
                    
                }) {
                    Image(systemName: "plus")
                }
                )
            
                .sheet(isPresented: $isAddBusinessViewShown) {
                    AddBusinessView(uploadToFirebase: false)
                    
                }
            
        }
    }
}

#Preview {
    BusinessView()
}
