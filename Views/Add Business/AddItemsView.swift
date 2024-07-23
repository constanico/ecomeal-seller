//
//  AddItemView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI

struct AddItemsView: View {
    @ObservedObject var businessViewModel: BusinessViewModel
    @ObservedObject var itemViewModel: ItemViewModel
    @State private var selectedIndex = 0
    @State private var isAddMenuItemSheetShown = false
    @State private var isEditMenuItemSheetShown = false
    @State private var isContextMenuShown = false
    @State private var isAlertForDeleteShown = false
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var businessInfo: Business
    @Binding var businessImage: UIImage
    @Binding var closeAllSheet: Bool
    @Binding var menuItems: [Item]
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                
                ScrollView{
                    if !menuItems.isEmpty{
                        HStack{
                            Text("Item List")
                                .bold()
                            Spacer()
                        }.padding()
                    }
                    ForEach(menuItems.indices, id: \.self) { index in
                        let item = menuItems[index]
                        ItemRowView(uiImage: item.image, itemName: item.itemName, oldPrice: item.itemOldPrice, newPrice: item.itemNewPrice, quantity: item.itemQuantity, weight: item.itemWeight, description: item.itemDescription ?? "No description.",
                                    
                                    onEdit:{
                            
                            self.selectedIndex = index
                            self.isEditMenuItemSheetShown.toggle()
                        },
                                    onDelete:{
                            isAlertForDeleteShown.toggle()
                        })
                        .alert("Delete this item (\(item.itemName))?", isPresented: $isAlertForDeleteShown) {
                            Button("Delete", role: .destructive) {
                                if index < menuItems.count {
                                    menuItems.remove(at: index)
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        
                        
                    }
                    Button(action: {
                        isAddMenuItemSheetShown = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                        Text("Add Menu Item")
                            .foregroundColor(.green)
                            .bold()
                            .frame(height: 50)
                            .cornerRadius(12)
                    }.padding(.top, 20)
                }
                .padding(.vertical, 20)
                .padding(.bottom, 80)
                
                VStack{
                    Spacer()
                    Button(action: {
                        addBusinessAndItems()
                    }) {
                        Text("Save and Add")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 300, height: 50)
                            .background(.green)
                            .cornerRadius(12)
                        
                    }.shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 3)
                    
                }.padding(.bottom, 30)
                
                
            }.edgesIgnoringSafeArea(.bottom)
            
        }.navigationTitle("Add Menu Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color(ColorString.lightGreen.colorText),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        
        
            .sheet(isPresented: $isAddMenuItemSheetShown) {
                AddMenuItemView(menuItems: $menuItems)
            }
        
            .sheet(isPresented: $isEditMenuItemSheetShown) {
                EditItemView(menuItem: $menuItems[selectedIndex])
            }
        
        
    }
    
    func addBusinessAndItems(){
        closeAllSheet = true
        presentationMode.wrappedValue.dismiss()
        
        let newBusiness = businessInfo
        businessViewModel.addBusiness(uuid: businessInfo.id ?? "1", business: newBusiness, image: businessImage)
        
        for item in menuItems{
            let newItem = BusinessItem(itemId: item.itemId, itemName: item.itemName, itemOldPrice: item.itemOldPrice, itemNewPrice: item.itemNewPrice, itemDescription: item.itemDescription, itemQuantity: item.itemQuantity, itemWeight: item.itemWeight, itemIsListed: true)
            
            itemViewModel.addItem(toBusiness: newBusiness.id ?? "1", item: newItem, image: item.image)
        }
    }
    
}

#Preview {
    AddItemsView(businessViewModel: BusinessViewModel(), itemViewModel: ItemViewModel(), businessInfo: .constant(emptyBusinessInfo), businessImage: .constant(UIImage(imageLiteralResourceName: "BusinessIcon")), closeAllSheet: .constant(false), menuItems: .constant(itemsDummy), latitude: .constant(0), longitude: .constant(0))
}
