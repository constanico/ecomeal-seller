//
//  AddMenuItemView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI

struct AddMenuItemView: View {
    @StateObject var itemViewModel = ItemViewModel()
    @Binding var menuItems: [Item]
    var business: Business?
    @Environment(\.presentationMode) var presentationMode
    
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    @State private var itemImage: UIImage = UIImage(imageLiteralResourceName: "FoodIcon")
    @State private var itemNameField: String = ""
    @State private var itemDescField: String = ""
    @State private var itemWeightField: Int = 0
    @State private var itemOldPriceField: Float = 0.0
    @State private var itemNewPriceField: Float = 0.0
    
    @State private var isPhotoPickerSheetPresented = false

    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                ScrollView{
                    VStack{
                        HStack{
                            Text("Item name")
                                .bold()
                            Spacer()
                        }
                        TextField("Item name", text: $itemNameField)
                            .textFieldStyle(OvalTextFieldStyle())
                            .padding(.bottom, 25)
                        
                        HStack{
                            Text("Item image")
                                .bold()
                            Spacer()
                           
                        }
                        
                        HStack{
                         
                                Image(uiImage: itemImage)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            
                            
                            Spacer()
                            Button(action: {
                                self.isPhotoPickerSheetPresented.toggle()
                            }) {
                                Image(systemName: "photo")
                                    .foregroundColor(.green)
                                Text("Choose Photo")
                                    .foregroundColor(.green)
                                    .bold()
                                    .frame(height: 50)
                                    .cornerRadius(12)
                            }
                        }.padding(.bottom, 25)
                        
                        HStack{
                            Text("Item old price (before discount)")
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Text(currencyString)
                            TextField("Enter price", value: $itemOldPriceField, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(OvalTextFieldStyle())
                        }.padding(.bottom, 15)
                        
                        HStack{
                            Text("Item new price (after discount)")
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Text(currencyString)
                            TextField("Enter price", value: $itemNewPriceField, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(OvalTextFieldStyle())
                        }.padding(.bottom, 15)
                        
                        HStack{
                            Text("Item weight")
                                .bold()
                            Spacer()
                        }
                        HStack{
                            TextField("Enter item weight", value: $itemWeightField, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(OvalTextFieldStyle())
                            Text("grams")
                        }.padding(.bottom, 15)
                        
                        HStack{
                            Text("Item description (optional)")
                                .bold()
                            Spacer()
                        }
                        TextEditor(text: $itemDescField)
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, y: 5)
                            .padding(.bottom, 25)
                        
                        Button(action: {
                            if !menuItems.isEmpty{
                                if menuItems[0] != uploadToFirebase{
                                    addMenuItem()
                                }else if business != nil{
                                    addBusinessItem()
                                }
                            }else{
                                addMenuItem()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Add Item")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 300, height: 50)
                                .background(.green)
                                .cornerRadius(12)
                            
                        }.shadow(color: .gray, radius: 3, x: 0, y: 2)
                           
                            
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 50)
                    .padding()
                }.modifier(KeyboardAwareModifier())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
            }.edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Add Menu Item")
                .toolbarBackground(
                    Color(ColorString.lightGreen.colorText),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            
                .navigationBarItems(trailing:
                                        Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black).opacity(0.6)
                
                }
                )
                
            
                .sheet(isPresented: $isPhotoPickerSheetPresented) {
                    PhotoPicker(selectedImage: $itemImage, onSelected: {})
                        .edgesIgnoringSafeArea(.bottom)
                }
        }
    }
    
    func addMenuItem(){
        
        if itemDescField == ""{
            itemDescField = "No description."
        }
        
        menuItems.append(Item(itemId: UUID().uuidString, itemName: itemNameField, itemOldPrice: itemOldPriceField, itemNewPrice: itemNewPriceField, itemDescription: itemDescField, itemQuantity: 1, itemWeight: itemWeightField, image: itemImage))
    }
    
    func addBusinessItem(){
        let item = BusinessItem(itemId: UUID().uuidString, itemName: itemNameField, itemOldPrice: itemOldPriceField, itemNewPrice: itemNewPriceField, itemDescription: itemDescField, itemQuantity: 1, itemWeight: itemWeightField, itemIsListed: true)
        itemViewModel.addItem(toBusiness: business?.id ?? "", item: item, image: itemImage)
    }
}

#Preview {
    AddMenuItemView(menuItems: .constant(itemsDummy), business: businessDummy)
}
