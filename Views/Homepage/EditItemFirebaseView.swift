//
//  EditItemFirebaseView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditItemFirebaseView: View {
    @StateObject var itemViewModel = ItemViewModel()
    @Binding var menuItem: BusinessItem
    @Environment(\.presentationMode) var presentationMode
    
    @State private var itemImage: UIImage = UIImage(imageLiteralResourceName: "FoodIcon")
    
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    @State private var isMapSheetPresented = false
    @State private var isPhotoPickerSheetPresented = false
    @Binding var newImage: UIImage
    @Binding var hasPickedImage: Bool
    
    var onUpdate: () -> Void

    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        HStack{
                            Text("Item name")
                                .bold()
                            Spacer()
                        }
                        TextField("Item name", text: $menuItem.itemName)
                            .textFieldStyle(OvalTextFieldStyle())
                            .padding(.bottom, 25)
                        
                        HStack{
                            Text("Item image")
                                .bold()
                            Spacer()
                           
                                
                        }
                        
                        HStack{
                            if !hasPickedImage{
                                WebImage(url: URL(string: menuItem.imageUrl ?? ""))
                                    .resizable()
                                    .placeholder(Image(systemName: "photo"))
                                    .frame(width: 60, height: 60)
                            }else{
                                Image(uiImage: newImage)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                            
                            Spacer()
                            Button(action: {
                                isPhotoPickerSheetPresented = true
                            
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
                            TextField("Enter price", value: $menuItem.itemOldPrice, formatter: NumberFormatter())
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
                            TextField("Enter price", value: $menuItem.itemNewPrice, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(OvalTextFieldStyle())
                        }.padding(.bottom, 15)
                        
                        HStack{
                            Text("Item weight")
                                .bold()
                            Spacer()
                        }
                        HStack{
                            TextField("Enter item weight", value: $menuItem.itemWeight, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(OvalTextFieldStyle())
                            Text("grams")
                        }.padding(.bottom, 15)
                        
                        HStack{
                            Text("Item description (optional)")
                                .bold()
                            Spacer()
                        }
                        TextEditor(text: Binding(
                            get: { menuItem.itemDescription ?? "" },
                            set: { newValue in menuItem.itemDescription = newValue }
                        ))
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, y: 5)
                            .padding(.bottom, 25)
                        
                        Button(action: {
                            onUpdate()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .bold()
                                .frame(width: 300, height: 50)
                                .background(.green)
                                .cornerRadius(12)
                            
                        }.shadow(color: .gray, radius: 3, x: 0, y: 2)
                            .padding(.bottom, 50)
                           
                        
                    }.padding(.horizontal, 10)
                        .padding(.bottom, 50)
                    .padding()
                    
                    
                }.modifier(KeyboardAwareModifier())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
            }.edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Edit Menu Item")
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
                    PhotoPicker(selectedImage: $newImage, onSelected: {
                        hasPickedImage = true
                    })
                    
                }
            
                .sheet(isPresented: $isMapSheetPresented) {
                    AddBusinessMapView(latitude: $latitude, longitude: $longitude)
                    
                }
        }
    }
}

#Preview {
    EditItemFirebaseView(menuItem: .constant(businessItemsDummy[0]), newImage: .constant(UIImage(imageLiteralResourceName: "FoodIcon")), hasPickedImage: .constant(true), onUpdate: {})
}
