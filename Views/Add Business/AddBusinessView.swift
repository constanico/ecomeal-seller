//
//  AddBusinessView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct AddBusinessView: View {
    @StateObject var businessViewModel = BusinessViewModel()
    @StateObject var itemViewModel = ItemViewModel()
    @State private var closeAllSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    @State private var menuItems: [Item] = []
    
    @State private var businessImage: UIImage = UIImage(imageLiteralResourceName: "BusinessIcon")
    
    @State private var businessInfo: Business = emptyBusinessInfo
    
    @State private var isMapSheetPresented = false
    @State private var moveToAddItemsView = false
    @State private var isPhotoPickerSheetPresented = false
    @State private var showAlert = false
    
    var uploadToFirebase: Bool
    var business: Business?
    @State private var hasPickedImage = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                ScrollView{
                    VStack{
                        HStack{
                            Text("Business name")
                                .bold()
                            Spacer()
                        }
                        TextField("Business name", text: $businessInfo.businessName)
                            .textFieldStyle(OvalTextFieldStyle())
                            .padding(.bottom, 25)
                        
                        HStack{
                            Text("Business image")
                                .bold()
                            Spacer()
                            
                            
                        }
                        
                        HStack{
                            if uploadToFirebase && !hasPickedImage{
                                WebImage(url: URL(string: business?.imageUrl ?? ""))
                                    .placeholder(Image(systemName: "photo"))
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                            else{
                                Image(uiImage: businessImage)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }
                           
                            
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
                            Text("Business category")
                                .bold()
                            Spacer()
                        }
                        TextField("Western, Asian, etc.", text: $businessInfo.businessCategory)
                            .textFieldStyle(OvalTextFieldStyle())
                            .padding(.bottom, 15)
                        
                        HStack{
                            Text("Address description")
                                .bold()
                            Spacer()
                        }
                        TextEditor(text: $businessInfo.businessAddress)
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, y: 5)
                            .padding(.bottom, 25)
                        
                        HStack{
                            Text("Location")
                                .bold()
                            Spacer()
                            Button(action: {
                                isMapSheetPresented = true
                            }) {
                                Image(systemName: "map")
                                    .foregroundColor(.green)
                                Text("Open Maps")
                                    .foregroundColor(.green)
                                    .bold()
                                    .frame(height: 50)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.bottom, 5)
                        
                        HStack{
                            Spacer()
                            Text("Latitude: \(latitude)")
                                .opacity(0.5)
                        }
                        
                        HStack{
                            Spacer()
                            Text("Longitude: \(longitude)")
                                .opacity(0.5)
                        }.padding(.bottom, 25)
                        
                        Button(action: {
                            if checkFields() && !uploadToFirebase{
                                saveBusinessInfo()
                                moveToAddItemsView = true
                            }else if checkFields() && uploadToFirebase{
                                uploadNewBusinessInfo()
                                presentationMode.wrappedValue.dismiss()
                            }
                            else{
                                showAlert = true
                            }
                        }) {
                            if !uploadToFirebase{
                                Text("Next")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: 300, height: 50)
                                    .background(.green)
                                    .cornerRadius(12)
                            }else{
                                Text("Save")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(width: 300, height: 50)
                                    .background(.green)
                                    .cornerRadius(12)
                            }
                            
                        }.shadow(color: .gray, radius: 3, x: 0, y: 2)
                            .alert("Please enter the fields or location.", isPresented: $showAlert) {
                                Button("OK", role: .cancel) { }
                            }
                        
                        
                    }.padding(.horizontal, 10)
                        .padding()
                }.modifier(KeyboardAwareModifier())
                    .onTapGesture {
                        hideKeyboard()
                    }
                
                NavigationLink(
                    destination: AddItemsView(businessViewModel: businessViewModel, itemViewModel: itemViewModel, businessInfo: $businessInfo, businessImage: $businessImage, closeAllSheet: $closeAllSheet, menuItems: $menuItems, latitude: $latitude, longitude: $longitude),
                    isActive: $moveToAddItemsView,
                    label: {
                        EmptyView()
                    })
                .hidden()
                
                
            }.edgesIgnoringSafeArea(.bottom)
                .navigationTitle(uploadToFirebase ? "Edit Business" : "Add Business")
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
                    PhotoPicker(selectedImage: self.$businessImage, onSelected: {}).edgesIgnoringSafeArea(.bottom)
                }
            
                .sheet(isPresented: $isMapSheetPresented) {
                    AddBusinessMapView(latitude: $latitude, longitude: $longitude)
                    
                }
            
                .onAppear{
                    if closeAllSheet{
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    if uploadToFirebase{
                        businessInfo = business ?? emptyBusinessInfo
                        latitude = business?.businessLatitude ?? 0
                        longitude = business?.businessLongitude ?? 0
                    }
                }
            
            
        }
        
    }
    
    func checkFields() -> Bool{
        if businessInfo.businessName.isEmpty || businessInfo.businessCategory.isEmpty || businessInfo.businessAddress.isEmpty{
            return false
        }else if latitude == 0.0 || longitude == 0.0{
            return false
        }
        return true
    }
    
    func saveBusinessInfo(){
        let uuid = UUID().uuidString
        businessInfo = Business(id: uuid, businessSellerId: Auth.auth().currentUser?.uid ?? "", businessId: uuid, businessName: self.businessInfo.businessName, businessCategory: self.businessInfo.businessCategory, businessRating: 0.0, businessLatitude: latitude, businessLongitude: longitude, businessAddress: self.businessInfo.businessAddress, businessIsOpen: self.businessInfo.businessIsOpen)
    }
    
    func uploadNewBusinessInfo(){
        businessInfo = Business(businessSellerId: Auth.auth().currentUser?.uid ?? "", businessId: self.businessInfo.businessId, businessName: self.businessInfo.businessName, businessCategory: self.businessInfo.businessCategory, businessRating: 0.0, businessLatitude: latitude, businessLongitude: businessInfo.businessLongitude, businessAddress: self.businessInfo.businessAddress, businessIsOpen: self.businessInfo.businessIsOpen)
        
        
        businessViewModel.editBusiness(businessId: business?.id ?? "", updatedBusiness: businessInfo, updatedImage: businessImage)
    }
}

#Preview {
    AddBusinessView(uploadToFirebase: false)
}
