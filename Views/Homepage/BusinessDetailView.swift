//
//  BusinessDetailView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import SDWebImageSwiftUI

struct BusinessDetailView: View {
    
    var business: Business
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedIndex = 0
    @State private var segmentedBarIndex = 0
    let segments = ["Show All", "Show Listed", "Show Unlisted"]
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    @State private var isAddItemSheetPresented = false
    @State private var isEditBusinessSheetPresented = false
    @State private var isEditSheetPresented = false
    @State private var isMapSheetPresented = false
    @State private var isReviewSheetPresented = false
    @State private var isItemCartSheetPresented = false
    @State private var isAlertForDeleteShown = false
    @State private var isAlertForDeleteBusinessShown = false
    
    @State private var useFirebase = [uploadToFirebase]
    
    @State private var hasPickedImage = false
    @State private var newImage = UIImage(imageLiteralResourceName: "FoodIcon")
    
    @StateObject var businessViewModel = BusinessViewModel()
    @StateObject var itemViewModel = ItemViewModel()
    
    var listedItems: [BusinessItem] {
        return itemViewModel.items.filter {
            $0.itemIsListed == true
        }
    }
    
    var unlistedItems: [BusinessItem] {
        return itemViewModel.items.filter {
            $0.itemIsListed == false
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                VStack{
                    
                    ScrollView{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.3), radius: 10, y: 5)
                            VStack{
                                HStack {
                                    WebImage(url: URL(string: business.imageUrl ?? ""))
                                        .resizable()
                                        .placeholder(Image(systemName: "photo"))
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(business.businessName)").font(.title2)
                                            .bold()
                                        
                                        Text(business.businessAddress)
                                            .foregroundColor(.gray)
                                        
                                        HStack{
                                            HStack{
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                                
                                                Text("\(String(format: "%.1f", business.businessRating)) ")
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    isEditBusinessSheetPresented.toggle()
                                                    
                                                }) {
                                                    HStack{
                                                        Image(systemName: "pencil")
                                                            .foregroundColor(.green)
                                                        Text("Edit")
                                                            .bold()
                                                            .foregroundColor(.green)
                                                        
                                                    } .frame(width: 100, height: 40)
                                                        .background(.green.opacity(0.1))
                                                        .cornerRadius(50)
                                                    
                                                }.padding(.bottom, -10)
                                                
                                                Menu{
                                                    Button(action: {
                                                        isAlertForDeleteBusinessShown.toggle()
                                                    }) {
                                                        Label("Delete Business", systemImage: "trash")
                                                    }
                                                    
                                                } label: {
                                                    Button(action: {
                                                    }) {
                                                        Image(systemName: "ellipsis")
                                                            .bold()
                                                            .frame(width: 50, height: 50)
                                                            .foregroundColor(.green)
                                                        
                                                        
                                                    }.frame(width: 40, height: 40)
                                                        .background(Color.green.opacity(0.1))
                                                        .cornerRadius(50)
                                                }.padding(.bottom, -10)
                                                
                                                
                                                
                                            }
                                        }.padding(.vertical, 5)
                                    }
                                }
                                .padding(.top, 25)
                                .padding(.bottom, 15)
                                
                                Divider()
                                    .background(Color.gray)
                                    .frame(height: 1)
                                
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.black.opacity(0.03))
                                        .frame(height: 80)
                                        .cornerRadius(10)
                                    HStack{
                                        
                                        Image(systemName: business.businessIsOpen ? "door.right.hand.open" : "door.right.hand.closed")
                                            .resizable()
                                            .frame(width: 20, height: 27)
                                            .opacity(0.5)
                                            .padding(.horizontal)
                                        
                                        VStack(alignment: .leading){
                                            
                                            Text("Business is").opacity(0.5)
                                                .font(.footnote)
                                            
                                            Text(business.businessIsOpen ? "Open" : "Closed").bold()
                                            
                                        }
                                        Spacer()
                                        
                                        Button(action: {
                                            openCloseBusiness(status: business.businessIsOpen ? false : true)
                                            
                                        }) {
                                            HStack{
                                                Text(business.businessIsOpen ? "Close" : "Open")
                                                    .bold()
                                                    .foregroundColor(.white)
                                                
                                            } .frame(width: 100, height: 40)
                                                .background(business.businessIsOpen ? .red : .green)
                                                .cornerRadius(50)
                                            
                                        }.padding(.horizontal)
                                    }
                                }.padding(.top)
                                
                                HStack{
                                    Button(action: {
                                        isReviewSheetPresented = true
                                        
                                    }) {
                                        Text("Reviews")
                                            .bold()
                                            .foregroundColor(.green)
                                        
                                    }.frame(width: 100, height: 40)
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(50)
                                        .padding(.horizontal, 5)
                                    
                                    
                                    Button(action: {
                                        isMapSheetPresented = true
                                        
                                    }) {
                                        Text("Location")
                                            .bold()
                                            .foregroundColor(.green)
                                        
                                    }.frame(width: 100, height: 40)
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(50)
                                        .padding(.horizontal, 5)
                                    
                                }.padding()
                                
                            }.padding(.horizontal, 20)
                            
                            
                        }.padding(.horizontal, 15)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        
                        HStack{
                            Text("Item List")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Picker(selection: $segmentedBarIndex, label: Text("Segments")) {
                                ForEach(0..<segments.count) { index in
                                    
                                    Text(self.segments[index])
                                        .foregroundColor(.black)
                                        .tag(index)
                                    
                                    
                                }
                            }
                            
                        }.padding(.horizontal, 20)
                        
                        if segmentedBarIndex == 0 || segmentedBarIndex == 1 {
                            if !listedItems.isEmpty{
                                HStack{
                                    Image(systemName: "checkmark.rectangle")
                                    Text("Listed items")
                                    Spacer()
                                }.padding()
                            }
                            ForEach(listedItems.indices, id: \.self) { index in
                                let item = listedItems[index]
                                ItemRowView(imageUrl: item.imageUrl ?? "", itemName: item.itemName, oldPrice: item.itemOldPrice, newPrice: item.itemNewPrice, quantity: item.itemQuantity, weight: item.itemWeight, description: item.itemDescription ?? "No description.", isListed: item.itemIsListed,
                                            onList:{
                                    changeListedStatus(item: item, isListed: false)
                                },
                                            onEdit:{
                                    self.selectedIndex = index
                                    isEditSheetPresented.toggle()
                                },
                                            onDelete:{
                                    self.selectedIndex = index
                                    isAlertForDeleteShown.toggle()
                                })
                            }.padding(.horizontal, 5)
                            
                        }
                        if segmentedBarIndex == 0 || segmentedBarIndex == 2{
                            if !unlistedItems.isEmpty{
                                HStack{
                                    Image(systemName: "xmark.rectangle")
                                    Text("Unlisted items")
                                    Spacer()
                                }.padding()
                            }
                            ForEach(unlistedItems.indices, id: \.self) { index in
                                let item = unlistedItems[index]
                                ItemRowView(imageUrl: item.imageUrl ?? "", itemName: item.itemName, oldPrice: item.itemOldPrice, newPrice: item.itemNewPrice, quantity: item.itemQuantity, weight: item.itemWeight, description: item.itemDescription ?? "No description.", isListed: item.itemIsListed,
                                            onList:{
                                    changeListedStatus(item: item, isListed: true)
                                },
                                            onEdit:{
                                    self.selectedIndex = index
                                    isEditSheetPresented.toggle()
                                },
                                            onDelete:{
                                    self.selectedIndex = index
                                    isAlertForDeleteShown.toggle()
                                })
                            }.padding(.horizontal, 5)
                        }
                    }
                    .alert("Delete this item?", isPresented: $isAlertForDeleteShown) {
                        Button("Delete", role: .destructive) {
                            deleteItem()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    
                    .alert("Delete business? This cannot be undone.", isPresented: $isAlertForDeleteBusinessShown) {
                        Button("Delete", role: .destructive) {
                            deleteBusiness()
                            presentationMode.wrappedValue.dismiss()
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    
                    
                }
                
                VStack{
                    Spacer()
                    HStack{
                        
                        Spacer()
                        Button(action: {
                            isAddItemSheetPresented.toggle()
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(.green)
                                .bold()
                                .cornerRadius(50)
                            
                        }.shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.bottom, 20)
                    }.padding(.horizontal, 25)
                }
                
                
            }
            
            .sheet(isPresented: $isEditBusinessSheetPresented){
                AddBusinessView(uploadToFirebase: true, business: business)
            }
            
            .sheet(isPresented: $isAddItemSheetPresented){
                AddMenuItemView(menuItems: $useFirebase, business: business)
            }
            
            .onAppear{
                itemViewModel.fetchItems(forBusiness: business.id ?? "1")
                latitude = business.businessLatitude
                longitude = business.businessLongitude
                
            }
        }.navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Manage Business")
            .toolbarBackground(
                Color(ColorString.lightGreen.colorText),
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        
        
            .sheet(isPresented: $isEditSheetPresented) {
                EditItemFirebaseView(menuItem: $itemViewModel.items[selectedIndex], newImage: $newImage, hasPickedImage: $hasPickedImage, onUpdate:{
                    editMenuItem()
                })
            }
        
            .sheet(isPresented: $isMapSheetPresented) {
                BusinessLocationView(latitude: $latitude, longitude: $longitude)
            }
        
      
         .sheet(isPresented: $isReviewSheetPresented) {
             ReviewsView(business: business)
         }
       
    }
    
    func changeListedStatus(item: BusinessItem, isListed: Bool){
        itemViewModel.currBusinessId = business.id ?? "1"
        itemViewModel.updateItemIsListed(item: item, isListed: isListed)
    }
    
    func openCloseBusiness(status: Bool) {
        businessViewModel.updateBusinessOpenStatus(businessId: business.id ?? "1", isOpen: status)
        
    }
    
    func editMenuItem(){
        itemViewModel.currBusinessId = business.id ?? "1"
        if hasPickedImage{
            itemViewModel.editItem(itemViewModel.items[selectedIndex], newItemData: itemViewModel.items[selectedIndex], newImage: newImage)
            self.hasPickedImage = false
        }else{
            itemViewModel.editItem(itemViewModel.items[selectedIndex], newItemData: itemViewModel.items[selectedIndex], newImage: nil)
        }
    }
    
    func deleteBusiness(){
        businessViewModel.deleteBusiness(businessId: business.id ?? "1")
    }
    
    func deleteItem(){
        itemViewModel.currBusinessId = business.id ?? "1"
        itemViewModel.deleteItem(itemViewModel.items[selectedIndex])
    }
    
}


struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(business: businessDummy, businessViewModel: BusinessViewModel())
    }
}
